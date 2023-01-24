CREATE OR REPLACE FUNCTION logging_my_table()
RETURNS TRIGGER AS $$
DECLARE
  -- 単一行コメントはハイフン2つ。C や Java と同じブロックコメントも書ける
  -- DECLARE は変数宣言のブロック。以下は「my_table」というテーブルの型を指定した「new_record」変数を定義している
  new_record my_table%ROWTYPE;
BEGIN
  -- インサートされた行は、組み込み変数「NEW」に設定されている
  new_record := NEW;
  -- 標準出力にログを出力する。「%」を使用して my_table の id カラムの値を表示させている
  RAISE LOG 'Inserted : %', new_record.id;
  
  # 以下の3つのレベルは標準出力にログが出てこなかった
  RAISE DEBUG 'Debug Level Log!';
  RAISE INFO 'Info Level Log!';
  RAISE NOTICE 'Notice Level Log!';
  # 以下の2つのレベルは標準出力にログが出た
  RAISE LOG 'Log Level Log!';
  RAISE WARNING 'Warning Level Log!';
  
  # 以下の2つはログ出力した行で処理が中止され、後続行が動作しない
  # RAISE のログレベル未指定は EXCEPTION と同義になる
  RAISE EXCEPTION 'Exception Level Log!';
  RAISE 'Raise Log!';
  
  -- インサート時のプロシージャでは戻り値を使わないので以下のように NULL を返す。RETURN を書かないと警告が出る
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

# プロシージャを実行するためのトリガーを作成する
DROP TRIGGER IF EXISTS trigger_my_table ON my_table;
CREATE TRIGGER trigger_my_table
  AFTER INSERT ON my_table
  FOR EACH ROW
  EXECUTE PROCEDURE logging_my_table();
