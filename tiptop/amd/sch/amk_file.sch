/*
================================================================================
檔案代號:amk_file
檔案名稱:申报税籍资料维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table amk_file
(
amk01       varchar2(10) DEFAULT ' ' NOT NULL, /*部门编码*/
amk02       number(5) DEFAULT '0' NOT NULL, /*年度*/
amk03       number(5) DEFAULT '0' NOT NULL, /*月份*/
amk04       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-专供课 */
amk05       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-专供课 */
amk06       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-专供课 */
amk07       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-共同使 */
amk08       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-共同使 */
amk09       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(进货及费用)-专供免 */
amk10       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-进项税额 */
amk11       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-专供课税 */
amk12       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-共同使用-*/
amk13       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-共同使用-*/
amk14       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-共同使用-*/
amk15       number(20,6) DEFAULT '0' NOT NULL, /*统一发票(固定资产)-专供免税 */
amk16       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-进项税额 */
amk17       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-专供课税 */
amk18       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-共同使用-*/
amk19       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-共同使用-*/
amk20       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-共同使用-*/
amk21       number(20,6) DEFAULT '0' NOT NULL, /*三联式(进货及费用)-专供免税 */
amk22       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-进项税额合 */
amk23       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-专供课税得 */
amk24       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-共同使用-小*/
amk25       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-共同使用-比*/
amk26       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-共同使用-比*/
amk27       number(20,6) DEFAULT '0' NOT NULL, /*三联式(固定资产)-专供免税不 */
amk28       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-进项税 */
amk29       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-专供课 */
amk30       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-共同使 */
amk31       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-共同使 */
amk32       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-共同使 */
amk33       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(进货及费用)-专供免 */
amk34       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-进项税额 */
amk35       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-专供课税 */
amk36       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-共同使用-*/
amk37       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-共同使用-*/
amk38       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-共同使用-*/
amk39       number(20,6) DEFAULT '0' NOT NULL, /*载有税额(固定资产)-专供免税 */
amk40       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(进货及费用)-进项税 */
amk41       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(进货及费用)-专供课 */
amk42       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(进货及费用)-共同使 */
amk43       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(进货及费用)-共同使 */
amk44       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(进货及费用)-共同使 */
amk45       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(进货及费用)-专供免 */
amk46       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(固定资产)-进项税额 */
amk47       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(固定资产)-专供课税 */
amk48       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(固定资产)-共同使用-*/
amk49       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(固定资产)-共同使用-*/
amk50       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(固定资产)-共同使用-*/
amk51       number(20,6) DEFAULT '0' NOT NULL, /*海关代征(固定资产)-专供免税 */
amk52       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-进项 */
amk53       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-专供 */
amk54       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-共同 */
amk55       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-共同 */
amk56       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-共同 */
amk57       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(进货及费用)-专供 */
amk58       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-进项税 */
amk59       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-专供课 */
amk60       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-共同使 */
amk61       number(20,6) DEFAULT '0' NOT NULL,
amk62       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-共同使 */
amk63       number(20,6) DEFAULT '0' NOT NULL, /*退出及折让(固定资产)-专供免 */
amk64       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-进项税额合 */
amk65       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-专供课税得 */
amk66       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-共同使用-小*/
amk67       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-共同使用-比*/
amk68       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-共同使用-比*/
amk69       number(20,6) DEFAULT '0' NOT NULL, /*合计(进货及费用)-专供免税不 */
amk70       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-进项税额合计(*/
amk71       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-专供课税得扣 */
amk72       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-共同使用-小计*/
amk73       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-共同使用-比例*/
amk74       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-共同使用-比例*/
amk75       number(20,6) DEFAULT '0' NOT NULL, /*合计(固定资产)-专供免税不得 */
amk76       number(20,6) DEFAULT '0' NOT NULL, /*得扣抵之进项税额合计(编号51)*/
amk77       number(20,6) DEFAULT '0' NOT NULL, /*不得扣抵比例*/
amk78       number(20,6) DEFAULT '0' NOT NULL, /*国外劳务-合计(编号74)*/
amk79       number(20,6) DEFAULT '0' NOT NULL, /*国外劳务-免税*/
amk80       number(20,6) DEFAULT '0' NOT NULL, /*国外劳务-共同使用*/
amk81       number(20,6) DEFAULT '0' NOT NULL, /*国外劳务-课税*/
amk82       number(20,6) DEFAULT '0' NOT NULL, /*应纳税额-合计(编号76)*/
amk83       number(20,6) DEFAULT '0' NOT NULL, /*应纳税额-免税*/
amk84       number(20,6) DEFAULT '0' NOT NULL /*应纳税额-共同使用*/
);

alter table amk_file add  constraint amk_pk primary key  (amk01,amk02,amk03) enable validate;
grant select on amk_file to tiptopgp;
grant update on amk_file to tiptopgp;
grant delete on amk_file to tiptopgp;
grant insert on amk_file to tiptopgp;
grant index on amk_file to public;
grant select on amk_file to ods;
