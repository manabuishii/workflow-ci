[![Build Status](https://travis-ci.org/manabuishii/workflow-ci.svg?branch=master)](https://travis-ci.org/manabuishii/workflow-ci)
[![CircleCI](https://circleci.com/gh/manabuishii/workflow-ci.svg?style=svg)](https://circleci.com/gh/manabuishii/workflow-ci)

# About License

Under `sampledata/DATA` is GPL License.
These data are copied from [CWL\-workflows/DATA at master · hacchy1983/CWL\-workflows](https://github.com/hacchy1983/CWL-workflows/tree/master/DATA)

Other files under this repository programs are MIT license.

# このレポジトリにあるもの

- CWL
  - bwa mem のコマンドラインツール
  - samtools view のコマンドラインツール
- BWA のテストデータ
  - 小さなインデックスと、配列データがある、でどころは、上に記述している
- Test
  - 上記のCWLに関するテスト
- CI
  - Travis CI の設定ファイル
    - python 3.6 の Linux でテスト
    - python 2系 のサポート切れが近いので、テストしない
    - python 3.7 の Linux のテストは、travis で標準サポートしていないようなので、やらない
    - mac での 3.6 も travis で標準サポートしていないようなので、やらない
  - Circle CI

# ローカル環境でのテストの実行の仕方

```
circleci local execute --job buildlocal
```

CircleCIのサービスでは、デフォルトの `build` タグが使われる。
なので、ローカルの方に、タグを付けた。

config のバージョン 2.1 になると、いろいろ制御できそうだが、
現在のローカル実行で使えないというエラーがでてくる

```
Error: 
You attempted to run a local build with version '2.1' of configuration.
Local builds do not support that version at this time.
You can use 'circleci config process' to pre-process your config into a version that local builds can run (see 'circleci help config process' for more information)
```

# workflow-ci

CWL workflow and test with travis-ci, CircleCI

#test

どうでしょう？

#test

See also: 雑に始める CWL!: https://qiita.com/tm_tn/items/4956f5ca523f7f49f386

# 

ヘルプでオプションの内容を確認する

```console
$ docker run --rm -it biocontainers/bwa:v0.7.12_cv3 bwa mem 
```

# validate する

```console
$ cwltool --validate workflow-ci/bwamem-ishii.cwl       
INFO /Users/manabu/work/20190725-workflow-meetup/wfenv/bin/cwltool 1.0.20190621234233
INFO Resolved 'workflow-ci/bwamem-ishii.cwl' to 'file:///Users/manabu/work/20190725-workflow-meetup/workflow-ci/bwamem-ishii.cwl'
workflow-ci/bwamem-ishii.cwl is valid CWL.
```

# テンプレートを作る

```console
$ cwltool --make-template bwamem-ishii.cwl > bwamem-ishii.yml
```

## 生成されたテンプレート

```yaml
reference:  # type "File"
    class: File
    path: a/file/path
fastq_reverse:  # type "File"
    class: File
    path: a/file/path
fastq_forward:  # type "File"
    class: File
    path: a/file/path
```

# ヘルプで確認


```console
$ cwltool bwamem-ishii.cwl --help
INFO /Users/manabu/work/20190725-workflow-meetup/wfenv/bin/cwltool 1.0.20190621234233
INFO Resolved 'bwamem-ishii.cwl' to 'file:///Users/manabu/work/20190725-workflow-meetup/workflow-ci/bwamem-ishii.cwl'
usage: bwamem-ishii.cwl [-h] --fastq_forward FASTQ_FORWARD --fastq_reverse
                        FASTQ_REVERSE --reference REFERENCE
                        [job_order]

positional arguments:
  job_order             Job input json file

optional arguments:
  -h, --help            show this help message and exit
  --fastq_forward FASTQ_FORWARD
  --fastq_reverse FASTQ_REVERSE
  --reference REFERENCE
                        BWA reference
```


# 

```console
$ cwltool --outdir=outputs bwamem-ishii.cwl bwamem-ishii.yml
```
# debug

parameter reference だけしかつかってないはずなのに、
InlineJavascriptRequirementが必要というエラーがでるときは、

パラメータ名に

```
    exec(execstr, myglobals, mylocals)
  File "<string>", line 1, in <module>
cwltool.errors.WorkflowException: bwamem-ishii.cwl:20:39: Expression evaluation error:
bwamem-ishii.cwl:20:39: Syntax error in parameter reference '(inputs.reference-bwt.nameroot)'. This could be due to using Javascript code without specifying InlineJavascriptRequirement.
(wfenv) ➜  workflow-ci git:(master) ✗ 
```

# 成功したときの出力、最後の行で成功したことがわかる

```
DEBUG Moving /private/tmp/docker_tmpgc_03_2f/output.sam to /Users/manabu/work/20190725-workflow-meetup/workflow-ci/outputs/output.sam
{
    "sam": {
        "location": "file:///Users/manabu/work/20190725-workflow-meetup/workflow-ci/outputs/output.sam",
        "basename": "output.sam",
        "class": "File",
        "checksum": "sha1$cf595bdea38b996de38228513e8931f15859ee88",
        "size": 11598069,
        "path": "/Users/manabu/work/20190725-workflow-meetup/workflow-ci/outputs/output.sam"
    }
}
INFO Final process status is success
```

# テストを書く

```console
$ pip install cwltest
```

# cwltest.yml を作る

```
output:
```

以下は、成功例のところで紹介した形式で埋めておく

cwltest.yml 全体
```yaml
- job: bwamem-ishii.yml # テストに使うパラメータを記述
  tool: bwamem-ishii.cwl # テストしたいCWLファイル
  output:
    sam:
      basename: "output.sam"
      class: "File"
      # checksum , size がないのは、毎回cwltoolから見えるディレクトリにはいってしまい
      # ヘッダー行に書き込まれてしまう
  label: bwamem-test
  id: bwamem
  doc: A test for bwa mem
  tags: [ command_line_tool ]
```

# cwl-runnerをインストール

cwltestを動かすためにいれる

```console
$ pip install cwl-runner
```

# テストを実行する。成功した場合

```console
$ cwltest --test cwltest.yml
Test [1/1] A test for bwa mem
All tests passed
```

# テスト

違いがわかる。

```console
0 tests passed, 1 failures, 0 unsupported features
(wfenv) ➜  workflow-ci git:(master) ✗ cwltest --test cwltest.yml
Test [1/1] A test for bwa mem
All tests passed
(wfenv) ➜  workflow-ci git:(master) ✗ cwltest --test cwltest.yml
Test [1/1] A test for bwa mem
Test 1 failed: cwl-runner --outdir=/var/folders/pw/tk62c1rs5mvg47fv0p1rx9p00000gn/T/tmptoa3woaj --quiet bwamem-ishii.cwl bwamem-ishii.yml
A test for bwa mem
Compare failure expected: {
    "sam": {
        "basename": "output.sam",
        "checksum": "sha1$cf595bdea38b996de38228513e8931f15859ee88",
        "class": "File"
    }
}
got: {
    "sam": {
        "basename": "output.sam",
        "checksum": "sha1$a34e09aaac1ce6c6a12c7c433534a074742e6c08",
        "class": "File",
        "location": "file:///var/folders/pw/tk62c1rs5mvg47fv0p1rx9p00000gn/T/tmptoa3woaj/output.sam",
        "path": "/var/folders/pw/tk62c1rs5mvg47fv0p1rx9p00000gn/T/tmptoa3woaj/output.sam",
        "size": 11598069
    }
}
caused by: failed comparison for key 'sam': expected: {
    "basename": "output.sam",
    "checksum": "sha1$cf595bdea38b996de38228513e8931f15859ee88",
    "class": "File"
}
got: {
    "basename": "output.sam",
    "checksum": "sha1$a34e09aaac1ce6c6a12c7c433534a074742e6c08",
    "class": "File",
    "location": "file:///var/folders/pw/tk62c1rs5mvg47fv0p1rx9p00000gn/T/tmptoa3woaj/output.sam",
    "path": "/var/folders/pw/tk62c1rs5mvg47fv0p1rx9p00000gn/T/tmptoa3woaj/output.sam",
    "size": 11598069
}
caused by: field 'checksum' failed comparison: expected: "sha1$cf595bdea38b996de38228513e8931f15859ee88"
got: "sha1$a34e09aaac1ce6c6a12c7c433534a074742e6c08"
0 tests passed, 1 failures, 0 unsupported features
(wfenv) ➜  workflow-ci git:(master) ✗ echo $?
1
```

# 生成されるコマンドを確認する

```console
$ docker pull ttanjo/cwl-inspector:v0.0.6
```




# streamable

- [続・雑に始める CWL！ \- Qiita](https://qiita.com/tm_tn/items/83ce4c826135d78ba98f)

# 今回使うデータのサンプル

- [CWL\-workflows/DATA at master · hacchy1983/CWL\-workflows](https://github.com/hacchy1983/CWL-workflows/tree/master/DATA)

clone なり、ソースをzipで固めたものなりを

# travisでうごかす

1. travisへいく
2. 右上のメニューから、Settingsをえらんで
3. workflow-ciを探す
4. スイッチオンにする。

＃ testtest
aa

# Circle CI でうごかす

## ローカル環境にインストールする

### brew でインストール

```
brew install circleci
```

### brew でいれたもののアンイストール

この方法でうまくいかないときは、

```
brew uninstall circleci
```

### 直接インストールする

```
curl -fLSs https://circle.ci/cli | sudo bash
```


## セットアップする

```
.circleci/config.yml
```

を作る

## 実際に実行する
```
circleci local execute
```

### 必要があれば、agent のバージョンをあげる

```
~/.circleci/build_agent_settings.json
```

を書き直す

```
{"LatestSha256":"sha256:463f8b03fa34e7609792bbc3e8983167fbb1221d9cefb1be401c0952973b3ebb"}
```

この、値の方( `sha256:` ではじまる方) の値を書き直すとうまくいくこともあるらしい。

## サービス側でまわす

## エラーへの対処

###

### 


```
E: Could not get lock /var/lib/apt/lists/lock - open (11: Resource temporarily unavailable)
```

[ここを参考に](https://discuss.circleci.com/t/could-not-get-lock-var-lib-apt-lists-lock/28337/6)

```
sudo killall -9 apt-get || true &&
```

を追加

