/*
================================================================================
檔案代號:sra_file
檔案名稱:机台(生产线)生产基本资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sra_file
(
sra01       varchar2(10) NOT NULL,   /*机台生产线                             */
sra02       varchar2(40) NOT NULL,   /*生产料号                               */
sra03       varchar2(4),             /*生产单位                               */
sra04       number(15,3),            /*每小时生产数量                         */
sraacti     varchar2(1),             /*有效否                                 */
sra05       number(9,3),             /*人工工时                               */
sra06       number(9,3),             /*机器工时                               */
sra07       number(8,4),             /*工资分摊率                             */
sra08       number(8,4)              /*制费分摊率                             */
);

alter table sra_file add  constraint sra_pk primary key  (sra01,sra02) enable validate;
grant select on sra_file to tiptopgp;
grant update on sra_file to tiptopgp;
grant delete on sra_file to tiptopgp;
grant insert on sra_file to tiptopgp;
grant index on sra_file to public;
grant select on sra_file to ods;
