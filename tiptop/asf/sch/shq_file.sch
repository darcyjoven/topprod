/*
================================================================================
檔案代號:shq_file
檔案名稱:RUN CARD分割资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shq_file
(
shq01       varchar2(20) NOT NULL,   /*分割单号                               */
                                     /*分割單號                               */
shq011      number(5) NOT NULL,      /*分割序号                               */
                                     /*分割序號                               */
shq02       varchar2(23),            /*新Run Card                             */
shq03       number(15,3),            /*拆批数量                               */
                                     /*拆批數量                               */
shq04       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
shq05       varchar2(1),             /*No Use                                 */
shq06       varchar2(1),             /*No Use                                 */
shq07       varchar2(1),             /*No Use                                 */
shq08       varchar2(1),             /*No Use                                 */
shq09       varchar2(1),             /*No Use                                 */
shq10       varchar2(1),             /*No Use                                 */
shqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index shq_02 on shq_file (shq03);
alter table shq_file add  constraint shq_pk primary key  (shq01,shq011) enable validate;
grant select on shq_file to tiptopgp;
grant update on shq_file to tiptopgp;
grant delete on shq_file to tiptopgp;
grant insert on shq_file to tiptopgp;
grant index on shq_file to public;
grant select on shq_file to ods;
