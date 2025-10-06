import eslint from "@eslint/js";
import prettier from "eslint-plugin-prettier/recommended";
import robloxTs from "eslint-plugin-roblox-ts";
import tseslint from "typescript-eslint";

export default [
    eslint.configs.recommended,
    ...tseslint.configs.recommended,
    prettier,
    {
        files: ["**/*.ts", "**/*.tsx"],
        languageOptions: {
            parser: tseslint.parser,
            parserOptions: {
                jsx: true,
                useJSXTextNode: true,
                ecmaVersion: 2018,
                sourceType: "module",
            },
        },
        plugins: {
            "roblox-ts": robloxTs,
        },
        rules: {
            "prefer-const": "off",
            "@typescript-eslint/no-empty-object-type": "off",
            "@typescript-eslint/no-require-imports": "off",
            "@typescript-eslint/no-namespace": "off",
            "@typescript-eslint/no-unused-vars": "off",
            "roblox-ts/no-private-identifier": "off",
            "roblox-ts/lua-truthiness": "off",
            "prettier/prettier": ["error", { endOfLine: "auto" }],
        },
    },
    {
        ignores: [
            "out/**",
            "node_modules/**",
            "docsout/**",
            "include/**",
            "test/**",
            "roact_exported/**",
            "src/shared/asset/AssetMap.ts",
        ],
    },
];
