/*
================================================================================
檔案代號:mmc_file
檔案名稱:加工码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mmc_file
(
mmc01       varchar2(10) NOT NULL,   /*加工码                                 */
                                     /*加工碼                                 */
mmc02       varchar2(80),            /*加工说明                               */
                                     /*加工說明                               */
mmcacti     varchar2(1),             /*资料有效码                             */
mmcuser     varchar2(10),            /*资料所有者                             */
                                     /*Data Owener                            */
                                     /*System Maintain                        */
mmcgrup     varchar2(10),            /*资料所有群                             */
                                     /*Data Group                             */
                                     /*System Maintain                        */
mmcmodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By                       */
                                     /*System Maimtain                        */
mmcdate     date,                    /*最近更改日                             */
                                     /*Latest Modified Date                   */
                                     /*System Maintain                        */
mmcorig     varchar2(10),            /*资料建立部门                           */
mmcoriu     varchar2(10)             /*资料建立者                             */
);

alter table mmc_file add  constraint mmc_pk primary key  (mmc01) enable validate;
grant select on mmc_file to tiptopgp;
grant update on mmc_file to tiptopgp;
grant delete on mmc_file to tiptopgp;
grant insert on mmc_file to tiptopgp;
grant index on mmc_file to public;
grant select on mmc_file to ods;
