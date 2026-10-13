/*
================================================================================
檔案代號:obd_file
檔案名稱:集團間銷售預測單身檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obd_file
(
obd01       varchar2(40),            /*料件編號                               */
obd02       varchar2(1),             /*計劃期別格式                           */
obd021      number(10),              /*起始期別                               */
obd03       number(5),               /*序號                                   */
obd04       number(10),              /*計劃期別                               */
obd05       varchar2(1),             /*No Use                                 */
obd06       number(20,6),            /*單價                                   */
obd07       number(20,6),            /*金額                                   */
obd08       number(15,3),            /*本階需求量                             */
obd09       number(15,3),            /*本階調整量                             */
obd10       number(15,3),            /*下階需求量                             */
obd11       number(15,3),            /*下階調整量                             */
obd12       number(15,3),            /*小計                                   */
obd13       varchar2(1),             /*No                                     */
obd14       varchar2(1),             /*No                                     */
obdconf     varchar2(1)              /*確認                                   */
);

create unique index obd_01 on obd_file (obd01,obd02,obd021,obd03);
grant select on obd_file to public;
grant index on obd_file to public;
grant update on obd_file to public;
grant delete on obd_file to public;
grant insert on obd_file to public;
