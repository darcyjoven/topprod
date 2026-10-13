/*
================================================================================
檔案代號:noa_file
檔案名稱:网银传输规则设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table noa_file
(
noa01       varchar2(10) DEFAULT ' ' NOT NULL, /*接口銀行編碼*/
noa02       varchar2(10) DEFAULT ' ' NOT NULL, /*版本编号*/
noa03       varchar2(50),            /*版本说明                               */
noa04       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
noa05       varchar2(10) DEFAULT ' ' NOT NULL, /*交易类型*/
noa06       varchar2(1) DEFAULT ' ' NOT NULL, /*傳輸格式*/
noa07       varchar2(1) DEFAULT ' ' NOT NULL, /*分隔符*/
noa08       varchar2(1) DEFAULT ' ' NOT NULL, /*支付文件分隔符*/
noa09       varchar2(20),            /*支付文件前綴                           */
noa10       varchar2(1) DEFAULT ' ' NOT NULL, /*支付文件編碼方式*/
noa11       varchar2(1) DEFAULT ' ' NOT NULL, /*支付文件格式*/
noa12       varchar2(80),            /*支付文件存放路徑                       */
noa13       varchar2(1) DEFAULT ' ' NOT NULL, /*默認版本否*/
noa14       varchar2(1) DEFAULT ' ' NOT NULL, /*報文類型*/
noaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
noadate     date,                    /*最近更改日                             */
noagrup     varchar2(10),            /*资料所有部门                           */
noamodu     varchar2(10),            /*资料更改者                             */
noaorig     varchar2(10),            /*资料建立部门                           */
noaoriu     varchar2(10),            /*资料建立者                             */
noauser     varchar2(10)             /*资料所有者                             */
);

create unique index noa_01 on noa_file (noa01,noa02,noa04,noa05,noa14);
alter table noa_file add  constraint noa_pk primary key  (noa01,noa02,noa04,noa05,noa14) enable validate;
grant select on noa_file to tiptopgp;
grant update on noa_file to tiptopgp;
grant delete on noa_file to tiptopgp;
grant insert on noa_file to tiptopgp;
grant index on noa_file to public;
grant select on noa_file to ods;
