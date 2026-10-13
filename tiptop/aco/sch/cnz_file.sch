/*
================================================================================
檔案代號:cnz_file
檔案名稱:撷取条件资料设置
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cnz_file
(
cnz01       varchar2(10) NOT NULL,   /*资料来源营运中心编号                   */
cnz02       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別                                   */
                                     /*1:出口/報廢明細擷取                    */
                                     /*2:進口明細擷取                         */
cnz03       number(5) NOT NULL,      /*行序                                   */
cnz04       varchar2(80),            /*条件                                   */
cnz05       varchar2(80),            /*说明                                   */
cnz06       varchar2(1),             /*No Use                                 */
cnz07       varchar2(1),             /*No Use                                 */
cnz08       varchar2(1),             /*No Use                                 */
cnzacti     varchar2(1),             /*资料有效码                             */
cnzuser     varchar2(10),            /*资料所有者                             */
cnzgrup     varchar2(10),            /*资料所有部门                           */
cnzmodu     varchar2(10),            /*资料更改者                             */
cnzdate     date,                    /*最近更改日                             */
cnzorig     varchar2(10),            /*资料建立部门                           */
cnzoriu     varchar2(10)             /*资料建立者                             */
);

alter table cnz_file add  constraint cnz_pk primary key  (cnz01,cnz02,cnz03) enable validate;
grant select on cnz_file to tiptopgp;
grant update on cnz_file to tiptopgp;
grant delete on cnz_file to tiptopgp;
grant insert on cnz_file to tiptopgp;
grant index on cnz_file to public;
grant select on cnz_file to ods;
