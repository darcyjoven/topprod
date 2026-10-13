/*
================================================================================
檔案代號:imh_file
檔案名稱:多单位库存调整单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imh_file
(
imh01       varchar2(20) NOT NULL,   /*库存调整单                             */
imh02       date,                    /*扣帐日期                               */
imh03       date,                    /*录入日期                               */
imh04       varchar2(40),            /*料号                                   */
imh05       varchar2(10),            /*仓库                                   */
imh06       varchar2(10),            /*库位                                   */
imh07       varchar2(24),            /*批号                                   */
imh08       varchar2(255),           /*备注                                   */
imh09       number(15,3),            /*库存数量                               */
imh10       varchar2(1),             /*No Use                                 */
imhpost     varchar2(1),             /*过帐码                                 */
                                     /*y': Posted                              */
                                     /*'n':Unposted                             */
                                     /*'x':Void                               */
imhuser     varchar2(10),            /*资料所有者                             */
imhgrup     varchar2(10),            /*资料所有群                             */
imhmodu     varchar2(10),            /*资料更改者                             */
imhdate     date,                    /*最近更改日                             */
imhconf     varchar2(1),             /*确认码                                 */
                                     /*(Y/N/X)                                */
imhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
imhorig     varchar2(10),            /*资料建立部门                           */
imhoriu     varchar2(10)             /*资料建立者                             */
);

alter table imh_file add  constraint imh_pk primary key  (imh01) enable validate;
grant select on imh_file to tiptopgp;
grant update on imh_file to tiptopgp;
grant delete on imh_file to tiptopgp;
grant insert on imh_file to tiptopgp;
grant index on imh_file to public;
grant select on imh_file to ods;
