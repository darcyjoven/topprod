/*
================================================================================
檔案代號:sgx_file
檔案名稱:工单工艺单元变更档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgx_file
(
sgx01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
sgx02       number(5) DEFAULT '0' NOT NULL, /*工艺序号*/
sgx03       number(5) DEFAULT '0' NOT NULL, /*单元变更序号*/
sgx04       varchar2(10),            /*变更原因                               */
sgx05       varchar2(80),            /*变更原因说明                           */
sgx06       date DEFAULT sysdate NOT NULL, /*变更日期*/
sgx07       date,                    /*发放日期                               */
sgx08       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
sgx09       varchar2(1) DEFAULT ' ' NOT NULL, /*发放码*/
sgxacti     varchar2(1),             /*资料有效码                             */
sgxdate     date,                    /*最近更改日                             */
sgxgrup     varchar2(10),            /*资料所属群组                           */
sgxmodu     varchar2(10),            /*资料更改者                             */
sgxuser     varchar2(10),            /*资料所有者                             */
sgxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sgxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
sgxoriu     varchar2(10),            /*资料建立者                             */
sgxorig     varchar2(10),            /*资料建立部门                           */
sgx012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table sgx_file add  constraint sgx_pk primary key  (sgx01,sgx02,sgx03,sgx012) enable validate;
grant select on sgx_file to tiptopgp;
grant update on sgx_file to tiptopgp;
grant delete on sgx_file to tiptopgp;
grant insert on sgx_file to tiptopgp;
grant index on sgx_file to public;
grant select on sgx_file to ods;
