import js from '@eslint/js';
import stylistic from '@stylistic/eslint-plugin';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  { files: ['js/**/*.ts'] },
  js.configs.recommended,
  tseslint.configs.recommended,
  stylistic.configs.customize({
    indent: 2,
    quotes: 'single',
    semi: true,
    jsx: false,
    commaDangle: 'never',
    braceStyle: '1tbs',
    arrowParens: false,
    quoteProps: 'as-needed'
  }),
  {
    // standard 相当に揃える (@stylistic の customize 既定と異なるもの)
    rules: {
      '@stylistic/space-before-function-paren': ['error', 'always'],
      '@stylistic/operator-linebreak': ['error', 'after', {
        overrides: { '?': 'before', ':': 'before', '|>': 'before' }
      }]
    }
  }
);
