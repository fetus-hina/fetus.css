#!/usr/bin/env php
<?php

declare(strict_types=1);

$codepoints = [];
while (!feof(STDIN)) {
    $line = fgets(STDIN);
    if (is_string($line)) {
        $cp = filter_var(trim($line), FILTER_VALIDATE_INT);
        if (is_int($cp)) {
            if (!in_array($cp, $codepoints, true)) {
                $codepoints[] = $cp;
            }
        }
    }
}

sort($codepoints, SORT_NUMERIC);

$results = [];

$start = null;
$prev = null;
foreach ($codepoints as $cp) {
    // 非連続があれば出力する
    if ($prev !== $cp - 1) {
        if ($prev !== null) {
            if ($start === $prev) {
                $results[] = sprintf('U+%X', $start);
            } else {
                $results[] = sprintf('U+%X-%X', $start, $prev);
            }
        }
        $start = $cp;
    }

    $prev = $cp;
}

if ($start !== null) {
    if ($start === $prev) {
        $results[] = sprintf('U+%X', $start);
    } else {
        $results[] = sprintf('U+%X-%X', $start, $prev);
    }
}

echo "unicode-range: '";
echo join(',', $results);
echo "',\n";
