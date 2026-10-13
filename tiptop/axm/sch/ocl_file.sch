/*
================================================================================
檔案代號:ocl_file
檔案名稱:产品替代原则资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ocl_file
(
ocl01       varchar2(10) NOT NULL,   /*产品分类                               */
ocl02       number(5) NOT NULL,      /*起始码                                 */
ocl03       number(5) NOT NULL,      /*截止码                                 */
ocl04       varchar2(20) NOT NULL,   /*原值                                   */
ocl05       varchar2(20),            /*替代值                                 */
ocl06       date NOT NULL,           /*生效日期                               */
ocl07       date                     /*失效日期                               */
);

alter table ocl_file add  constraint ocl_pk primary key  (ocl01,ocl02,ocl03,ocl04,ocl06) enable validate;
grant select on ocl_file to tiptopgp;
grant update on ocl_file to tiptopgp;
grant delete on ocl_file to tiptopgp;
grant insert on ocl_file to tiptopgp;
grant index on ocl_file to public;
grant select on ocl_file to ods;
