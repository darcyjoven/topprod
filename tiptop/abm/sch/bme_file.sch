/*
================================================================================
檔案代號:bme_file
檔案名稱:联产品关系明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bme_file
(
bme01       varchar2(40) NOT NULL,   /*主产品料件编号                         */
                                     /*主產品料件編號                         */
bme02       varchar2(40) NOT NULL,   /*可产出产品料件编号                     */
                                     /*可產出產品料件編號                     */
bme03       varchar2(1),             /*No Use                                 */
bme04       varchar2(1),             /*No Use                                 */
bme05       varchar2(1),             /*No Use                                 */
bmeuser     varchar2(10),            /*资料所有者                             */
                                     /*Data Owener                            */
                                     /*System Maintain                        */
bmegrup     varchar2(10),            /*资料所有群                             */
                                     /*Data Group                             */
                                     /*System Maintain                        */
bmemodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By                       */
                                     /*System Maimtain                        */
bmedate     date,                    /*最近更改日                             */
                                     /*Latest Modified Date                   */
                                     /*System Maintain                        */
bmeacti     varchar2(1),             /*资料有效码                             */
                                     /*Data Valid Code                        */
                                     /*System Maintain                        */
bmeorig     varchar2(10),            /*资料建立部门                           */
bmeoriu     varchar2(10)             /*资料建立者                             */
);

alter table bme_file add  constraint bme_pk primary key  (bme01,bme02) enable validate;
grant select on bme_file to tiptopgp;
grant update on bme_file to tiptopgp;
grant delete on bme_file to tiptopgp;
grant insert on bme_file to tiptopgp;
grant index on bme_file to public;
grant select on bme_file to ods;
