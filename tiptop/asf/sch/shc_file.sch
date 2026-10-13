/*
================================================================================
檔案代號:shc_file
檔案名稱:工单生产日报单身缺点码维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shc_file
(
shc01       varchar2(20) NOT NULL,   /*移转单号                               */
                                     /*移轉單號                               */
shc03       number(5) NOT NULL,      /*行序                                   */
shc04       varchar2(10),            /*缺点码                                 */
                                     /*缺點碼                                 */
shc05       number(15,3),            /*数量                                   */
                                     /*數量                                   */
shc06       number(5),               /*责任归属工艺                           */
                                     /*責任歸屬製程                           */
shc07       varchar2(1),             /*No Use                                 */
shcacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
shcuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
shcgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
shcmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
shcdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
shcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shclegal    varchar2(10) NOT NULL,   /*所属法人                               */
shcorig     varchar2(10),            /*资料建立部门                           */
shcoriu     varchar2(10),            /*资料建立者                             */
shc012      varchar2(10)             /*责任归属工艺段                         */
);

alter table shc_file add  constraint shc_pk primary key  (shc01,shc03) enable validate;
grant select on shc_file to tiptopgp;
grant update on shc_file to tiptopgp;
grant delete on shc_file to tiptopgp;
grant insert on shc_file to tiptopgp;
grant index on shc_file to public;
grant select on shc_file to ods;
