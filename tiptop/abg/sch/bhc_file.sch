/*
================================================================================
檔案代號:bhc_file
檔案名稱:分摊基础设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bhc_file
(
bhc01       varchar2(10) NOT NULL,   /*部门                                   */
                                     /*部門                                   */
bhc02       varchar2(6) NOT NULL,    /*分摊类型                               */
                                     /*分攤類別                               */
bhc03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
bhc04       varchar2(24) NOT NULL,   /*会计科目                               */
                                     /*會計科目                               */
bhc05       varchar2(10) NOT NULL,   /*被分摊部门                             */
                                     /*被分攤部門                             */
bhc06       varchar2(1),             /*No Use                                 */
bhc07       number(15,3)             /*分摊基础                               */
                                     /*分攤基礎                               */
);

alter table bhc_file add  constraint bhc_pk primary key  (bhc01,bhc02,bhc03,bhc04,bhc05) enable validate;
grant select on bhc_file to tiptopgp;
grant update on bhc_file to tiptopgp;
grant delete on bhc_file to tiptopgp;
grant insert on bhc_file to tiptopgp;
grant index on bhc_file to public;
grant select on bhc_file to ods;
