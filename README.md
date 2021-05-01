# extract submissions

```
./extract-submissions.sh in-dir out-dir question-number
```

`in-dir` input directory of zip files
`out-dir` directory where questions will end up
`question-number` question number to extract

No slashes at the end of directory names pls.

Say you have a directory called `files`
```
  Alice.zip
  Bob.zip
  Charlie.zip
```

each of these contain the coursework in the expected format, and you want to get, for example question 3 and store it in
`processed`.

`./extract-submissions.zip files processed 3`

processed will look something like this:
```
  Alice-Q3/
  Bob-Q3/
  Charlie-Q3/
``

If a zip file does not contain the required question, a warning will be printed.

