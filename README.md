Language: [English](README.md)

# json_dart_generator
[![Pub](https://img.shields.io/pub/v/json_localization_translator.svg?style=flat-square)](https://pub.dartlang.org/packages/json_localization_translator)

json localization data translator,

based on the 'translator' package

example: source 'en'
```json
{
   "hello": "hello",
   "yellow": "yellow",
   "inner": {
      "test": "inside",
      "confirm": "confirm",
      "depth": {
         "depthTitle": "title"
      }
   }
}
```

example: translate 'zh-tw'
```json
{
   "hello": "你好",
   "yellow": "黃色的",
   "inner": {
      "test": "裡面",
      "confirm": "確認",
      "depth": {
         "depthTitle": "標題"
      }
   }
}
```


## Usage

#### 1. Use this package as an executable
1. Activating a package

        dart pub global activate json_localization_translator

2. Running

        json_localization_translator translate -i {input_file} -o {output_file} -f {from_language} -t {to_language}

3. Command Line Arguments
    ```shell script
    translate            translate command
    -i, --in             input file
    -o, --out            output file
    -f, --from           from language
    -t, --to             to language
    -h, --[no-]help      description
    ```

(If thrown error `command not found` on step1, check [this](https://dart.cn/tools/pub/cmd/pub-global) add path to env) 
