/*
================================================================================
檔案代號:fcj_file
檔案名稱:投资抵减附加费用档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fcj_file
(
fcj01       varchar2(20) NOT NULL,   /*申请编号                               */
fcj02       number(5),               /*项次                                   */
fcj03       varchar2(10) NOT NULL,   /*财产编号                               */
fcj031      varchar2(4) NOT NULL,    /*附号                                   */
fcj04       varchar2(80),            /*中文名称                               */
fcj05       varchar2(80),            /*英文名称                               */
fcj06       number(5),               /*数量                                   */
fcj07       varchar2(4),             /*单位                                   */
fcj08       varchar2(10),            /*厂商名称                               */
fcj09       number(20,6),            /*原币成本                               */
fcj10       varchar2(4),             /*原币币种                               */
fcj11       number(20,6),            /*本币成本                               */
fcjconf     varchar2(1),             /*审核否                                 */
fcjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fcj_file add  constraint fcj_pk primary key  (fcj01,fcj03,fcj031) enable validate;
grant select on fcj_file to tiptopgp;
grant update on fcj_file to tiptopgp;
grant delete on fcj_file to tiptopgp;
grant insert on fcj_file to tiptopgp;
grant index on fcj_file to public;
grant select on fcj_file to ods;
