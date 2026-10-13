/*
================================================================================
檔案代號:gei_file
檔案名稱:编码类型资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gei_file
(
gei01       varchar2(10) NOT NULL,   /*编码类型                               */
                                     /*編碼類別                               */
gei02       varchar2(80),            /*名称                                   */
                                     /*名稱                                   */
gei03       varchar2(2),             /*性质                                   */
                                     /*性質                                   */
gei04       number(5),               /*总段数                                 */
                                     /*總段數                                 */
gei05       number(5),               /*总长度                                 */
                                     /*總長度                                 */
gei06       varchar2(1),             /*No Use                                 */
gei07       varchar2(1),             /*No Use                                 */
geiacti     varchar2(1),             /*资料有效码                             */
geiuser     varchar2(10),            /*资料所有者                             */
geigrup     varchar2(10),            /*资料所有部门                           */
geimodu     varchar2(10),            /*资料更改者                             */
geidate     date,                    /*最近更改日                             */
geioriu     varchar2(10),            /*资料建立者                             */
geiorig     varchar2(10),            /*资料建立部门                           */
gei08       varchar2(1)              /*条码使用否                             */
);

alter table gei_file add  constraint gei_pk primary key  (gei01) enable validate;
grant select on gei_file to tiptopgp;
grant update on gei_file to tiptopgp;
grant delete on gei_file to tiptopgp;
grant insert on gei_file to tiptopgp;
grant index on gei_file to public;
grant select on gei_file to ods;
