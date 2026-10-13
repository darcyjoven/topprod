/*
================================================================================
檔案代號:lsa_file
檔案名稱:日結作業檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table lsa_file
(
lsa01       date DEFAULT sysdate NOT NULL, /*日结日期*/
lsa02       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位号*/
lsa03       varchar2(20) DEFAULT ' ' NOT NULL, /*合同号*/
lsa04       varchar2(10) DEFAULT ' ' NOT NULL, /*商户号*/
lsa05       varchar2(10),            /*楼栋编号                               */
lsa06       varchar2(10),            /*楼层编号                               */
lsa07       varchar2(10),            /*产品分类                               */
lsa08       varchar2(10),            /*No Use                                 */
lsa09       varchar2(10),            /*No Use                                 */
lsa10       varchar2(2) DEFAULT ' ' NOT NULL, /*No Use*/
lsa11       number(20,2) DEFAULT '0' NOT NULL, /*金额*/
lsa12       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsa13       varchar2(20),            /*No Use                                 */
lsalegal    varchar2(10) NOT NULL,   /*所属法人                               */
lsaplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lsa_file add  constraint lsa_pk primary key  (lsa01,lsa02,lsa03,lsa04,lsa10,lsa12) enable validate;
grant select on lsa_file to tiptopgp;
grant update on lsa_file to tiptopgp;
grant delete on lsa_file to tiptopgp;
grant insert on lsa_file to tiptopgp;
grant index on lsa_file to public;
grant select on lsa_file to ods;
