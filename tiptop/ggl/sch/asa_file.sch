/*
================================================================================
檔案代號:asa_file
檔案名稱:关联企业层级维护作业(单头)
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asa_file
(
asa01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asa02       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
asa03       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套编号*/
asa04       varchar2(1) DEFAULT ' ' NOT NULL, /*是否为最上层公司*/
asa05       varchar2(1),             /*平均汇率计算方式                       */
asa06       varchar2(1),             /*编制合并期别                           */
asa07       varchar2(1) DEFAULT 'N' NOT NULL, /*分层合并否*/
asa08       varchar2(1),             /*NO USE                                 */
asa09       varchar2(1),             /*对了会科合并                           */
asaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
asadate     date,                    /*最近更改日                             */
asagrup     varchar2(10),            /*资料所有群                             */
asamodu     varchar2(10),            /*资料更改者                             */
asaorig     varchar2(10),            /*资料建立部门                           */
asaoriu     varchar2(10),            /*资料建立者                             */
asauser     varchar2(10)             /*资料所有者                             */
);

alter table asa_file add  constraint asa_pk primary key  (asa01,asa02,asa03) enable validate;
grant select on asa_file to tiptopgp;
grant update on asa_file to tiptopgp;
grant delete on asa_file to tiptopgp;
grant insert on asa_file to tiptopgp;
grant index on asa_file to public;
grant select on asa_file to ods;
