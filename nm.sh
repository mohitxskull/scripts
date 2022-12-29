#!/bin/bash

project_name=$1

if [ -z "$project_name" ]; then
    echo "Please provide a project name"
    echo "Usage: nextMen.sh <project_name>"
    echo "Example: nextMen.sh my-next-app"
    echo ""
    exit 1
fi

# check yarn is installed
if ! command -v yarn &>/dev/null; then
    # in red
    echo ""
    echo -e "\033[0;31mYarn is not installed\033[0m"
    echo ""
    exit
fi

# check project name is valid
if [[ ! $project_name =~ ^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*$ ]]; then
    # in red
    echo ""
    echo -e "\033[0;31mProject name is not valid\033[0m"
    echo ""
fi

# check project name is not already taken
if [ -d "$project_name" ]; then
    # in red
    echo ""
    echo -e "\033[0;31mProject name is already taken\033[0m"
    echo ""

else
    # in green
    echo ""
    echo -e "\033[0;32mCreating project\033[0m"
    echo ""
    yarn create next-app --typescript --eslint $project_name
fi

# check if project was created
if [ -d "$project_name" ]; then
    # in green
    echo ""
    echo -e "\033[0;32mProject created\033[0m"
    echo ""
else
    # in red
    echo ""
    echo -e "\033[0;31mProject not created\033[0m"
    echo ""
    exit 1
fi

# going in
cd $project_name
yarn add @mantine/core @mantine/hooks @mantine/next @emotion/server @emotion/react

rm -rf pages/api public styles .eslintrc.json

mkdir styles
mkdir public
touch styles/world.css

cat >"pages/_document.tsx" <<EOF
import { createGetInitialProps } from '@mantine/next';
import Document, { Head, Html, Main, NextScript } from 'next/document';

const getInitialProps = createGetInitialProps();

export default class _Document extends Document {
  static getInitialProps = getInitialProps;

  render() {
    return (
      <Html>
        <Head />
        <body>
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}
EOF

cat >"pages/_app.tsx" <<EOF
import { AppProps } from 'next/app';
import Head from 'next/head';
import { MantineProvider } from '@mantine/core';
import '../styles/world.css';

export default function App(props: AppProps) {
  const { Component, pageProps } = props;

  return (
    <>
      <Head>
        <title>$project_name</title>
        <meta name='viewport' content='minimum-scale=1, initial-scale=1, width=device-width' />
      </Head>

      <MantineProvider
        withGlobalStyles
        withNormalizeCSS
        theme={{
          /** Put your mantine theme override here */
          colorScheme: 'light',
        }}
      >
        <Component {...pageProps} />
      </MantineProvider>
    </>
  );
}
EOF

npx install-peerdeps --dev eslint-config-mantine

cat >".eslintrc.json" <<EOF
{
  "extends": ["mantine", "next/core-web-vitals"],
  "parserOptions": {
    "project": "./tsconfig.json"
  }
}
EOF

cat >"pages/index.tsx" <<EOF
import React from "react";
import { NextPage } from 'next';

const Index: NextPage = () => {
  return (
    <>
      <span>$project_name</span>
    </>
  );
};

export default Index;
EOF
