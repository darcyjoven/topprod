/*
================================================================================
檔案代號:opn_file
檔案名稱:产品别预计产量单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table opn_file
(
opn01       varchar2(10) NOT NULL,   /*产品别                                 */
                                     /*產品別                                 */
opn02       varchar2(10) NOT NULL,   /*版本                                   */
opn03       number(5) NOT NULL,      /*年度                                   */
opn04       number(5) NOT NULL,      /*月份                                   */
opn05       number(15,3),            /*计划数量                               */
                                     /*計劃數量                               */
opn06       varchar2(1),             /*No Use                                 */
opn07       varchar2(1),             /*No Use                                 */
opn08       varchar2(1),             /*No Use                                 */
opnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
opnlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table opn_file add  constraint opn_pk primary key  (opn01,opn02,opn03,opn04) enable validate;
grant select on opn_file to tiptopgp;
grant update on opn_file to tiptopgp;
grant delete on opn_file to tiptopgp;
grant insert on opn_file to tiptopgp;
grant index on opn_file to public;
grant select on opn_file to ods;
