/*
================================================================================
檔案代號:nob_file
檔案名稱:网银传输规则设定单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nob_file
(
nob01       varchar2(10) DEFAULT ' ' NOT NULL, /*接口銀行編碼*/
nob02       varchar2(10) DEFAULT ' ' NOT NULL, /*版本编号*/
nob03       varchar2(10) DEFAULT ' ' NOT NULL, /*交易类型*/
nob04       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
nob05       number(5) DEFAULT '0' NOT NULL, /*序号*/
nob06       varchar2(40),            /*銀行字段名                             */
nob07       varchar2(40),            /*中文说明                               */
nob08       varchar2(1) DEFAULT ' ' NOT NULL, /*取值來源*/
nob09       varchar2(40),            /*固定值                                 */
nob10       varchar2(15),            /*TIPTOP表                               */
nob11       varchar2(10),            /*TIPTOP取值字段                         */
nob12       varchar2(50),            /*关联条件                               */
nob13       varchar2(10),            /*类型                                   */
nob14       varchar2(1) DEFAULT ' ' NOT NULL, /*是否必輸*/
nob15       number(5),               /*最大長度                               */
nob16       varchar2(1) DEFAULT ' ' NOT NULL, /*不足需補字符*/
nob17       varchar2(5),             /*补何字符                               */
nob18       varchar2(2),             /*补字符位置                             */
nob19       varchar2(1) DEFAULT ' ' NOT NULL, /*是否控制小數位數*/
nob20       number(5),               /*小数位数                               */
nob21       varchar2(1) DEFAULT ' ' NOT NULL, /*多域串*/
nob22       varchar2(1) DEFAULT ' ' NOT NULL, /*多域串分隔符*/
nob23       varchar2(100),           /*备注                                   */
nob24       varchar2(1) DEFAULT ' ' NOT NULL, /*報文類型*/
nobacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
nobdate     date,                    /*最近更改日                             */
nobgrup     varchar2(10),            /*资料所有部门                           */
nobmodu     varchar2(10),            /*资料更改者                             */
noborig     varchar2(10),            /*资料建立部门                           */
noboriu     varchar2(10),            /*资料建立者                             */
nobuser     varchar2(10)             /*资料所有者                             */
);

alter table nob_file add  constraint nob_pk primary key  (nob01,nob02,nob03,nob04,nob05,nob24) enable validate;
grant select on nob_file to tiptopgp;
grant update on nob_file to tiptopgp;
grant delete on nob_file to tiptopgp;
grant insert on nob_file to tiptopgp;
grant index on nob_file to public;
grant select on nob_file to ods;
