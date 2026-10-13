/*
================================================================================
檔案代號:wcg_file
檔案名稱:整合产品交易处理LOG纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table wcg_file
(
wcg01       varchar2(17) DEFAULT ' ' NOT NULL, /*流水号(key)*/
wcg02       date DEFAULT sysdate NOT NULL, /*处理日期*/
wcg03       varchar2(12) DEFAULT ' ' NOT NULL, /*处理时间*/
wcg04       varchar2(10),            /*整合产品代号                           */
wcg05       varchar2(20),            /*数据库名称                             */
wcg06       varchar2(20) DEFAULT ' ' NOT NULL, /*DataKey*/
wcg07       varchar2(2) DEFAULT ' ' NOT NULL, /*流程节点*/
wcg08       varchar2(20),            /*程序代码                               */
wcg09       varchar2(8),             /*信息代码                               */
wcg10       clob,                    /*所属法人                               */
wcg11       clob,                    /*Request XML                            */
wcg12       clob,                    /*Response XML                           */
wcglegal    varchar2(10) NOT NULL,   /*所属法人                               */
wcgplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

create        index wcg_02 on wcg_file (wcg06);
create        index wcg_03 on wcg_file (wcg02,wcg06);
alter table wcg_file add  constraint wcg_pk primary key  (wcg01) enable validate;
grant select on wcg_file to tiptopgp;
grant update on wcg_file to tiptopgp;
grant delete on wcg_file to tiptopgp;
grant insert on wcg_file to tiptopgp;
grant index on wcg_file to public;
grant select on wcg_file to ods;
