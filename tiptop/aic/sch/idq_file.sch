/*
================================================================================
檔案代號:idq_file
檔案名稱:ICD收貨單自動產生log檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table idq_file
(
idq01       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
idq02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
idq03       number(5) DEFAULT '0' NOT NULL, /*處理項次*/
idq04       date,                    /*處理日期時間                           */
idq05       varchar2(1),             /*处理成功否                             */
idq06       varchar2(20) DEFAULT ' ' NOT NULL, /*采购单号*/
idq07       number(5) DEFAULT '0' NOT NULL, /*采购项次*/
idq08       varchar2(20),            /*收货单号                               */
idq09       number(5),               /*收货项次                               */
idq10       varchar2(20),            /*入库单号                               */
idq11       number(5),               /*入库项次                               */
idq12       varchar2(80),            /*错误信息                               */
idq13       varchar2(80)             /*錯誤代號                               */
);

alter table idq_file add  constraint idq_pk primary key  (idq01,idq02,idq03,idq06,idq07) enable validate;
grant select on idq_file to tiptopgp;
grant update on idq_file to tiptopgp;
grant delete on idq_file to tiptopgp;
grant insert on idq_file to tiptopgp;
grant index on idq_file to public;
grant select on idq_file to ods;
