/*
================================================================================
檔案代號:shs_file
檔案名稱:RUN CARD合并资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shs_file
(
shs01       varchar2(20) NOT NULL,   /*合并单号                               */
                                     /*合併單號                               */
shs011      number(5),               /*合并项次                               */
                                     /*合併項次                               */
shs02       varchar2(23) DEFAULT ' ' NOT NULL, /*Run Card*/
                                     /*要合併的Run Card                       */
shs03       number(15,3),            /*WIP 数量                               */
                                     /*WIP 數量                               */
shs04       varchar2(30),            /*合并数量                               */
                                     /*合併數量                               */
shs05       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
shs06       varchar2(1),             /*No Use                                 */
shs07       varchar2(1),             /*No Use                                 */
shs08       varchar2(1),             /*No Use                                 */
shs09       varchar2(1),             /*No Use                                 */
shs10       varchar2(1),             /*No Use                                 */
shsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shslegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table shs_file add  constraint shs_pk primary key  (shs01,shs02) enable validate;
grant select on shs_file to tiptopgp;
grant update on shs_file to tiptopgp;
grant delete on shs_file to tiptopgp;
grant insert on shs_file to tiptopgp;
grant index on shs_file to public;
grant select on shs_file to ods;
