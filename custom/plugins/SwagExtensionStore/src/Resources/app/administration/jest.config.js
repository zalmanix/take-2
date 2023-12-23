// For a detailed explanation regarding each configuration property, visit:
// https://jestjs.io/docs/en/configuration.html
module.exports = {
    preset: '@shopware-ag/jest-preset-sw6-admin',
    globals: {
        // required, e.g. /www/sw6/platform/src/Administration/Resources/app/administration
        adminPath: process.env.ADMIN_PATH
    },

    collectCoverageFrom: [
        '<rootDir>/src/**/*.js',
        '<rootDir>/src/**/*.ts',
        '!<rootDir>/src/**/*.spec.js',
        '!<rootDir>/src/**/*.spec.ts',
    ],

    moduleNameMapper: {
        '^SwagExtensionStore(.*)$': '<rootDir>/src$1',
        // Force module uuid to resolve with the CJS entry point, because Jest does not support package.json.exports.
        // See https://github.com/uuidjs/uuid/issues/451
        '^uuid$': require.resolve('uuid'),
        '^\@shopware-ag\/admin-extension-sdk\/es\/(.*)': `${process.env.ADMIN_PATH}/node_modules/@shopware-ag/admin-extension-sdk/umd/$1`
    }
};
