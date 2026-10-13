/*
================================================================================
檔案代號:rpi_file
檔案名稱:产品组合过暂存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rpi_file
(
rpi01       varchar2(40) NOT NULL,   /*最终规格料件编号                       */
                                     /*最終規格料件編號                       */
rpi03       number(5),               /*项次                                   */
                                     /*項次                                   */
rpi04       varchar2(40) NOT NULL,   /*主件编号                               */
                                     /*主件編號                               */
rpi05       varchar2(40) NOT NULL,   /*元件编号                               */
                                     /*元件編號                               */
rpi06       varchar2(1),             /*选择                                   */
                                     /*選擇                                   */
rpi07       varchar2(1),             /*组合                                   */
                                     /*組合                                   */
rpi08       varchar2(1),             /*必要                                   */
rpi09       number(20,8),            /*单位用量                               */
                                     /*單位用量                               */
rpi10       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
rpi11       number(5),               /*顺序                                   */
                                     /*順序                                   */
rpi12       varchar2(80),            /*结构方式                               */
                                     /*結構方式: 主件-LEVEL                   */
rpi13       varchar2(1),             /*更新码                                 */
                                     /*更新碼                                 */
rpi14       varchar2(1),             /*主件必要性                             */
rpi15       number(16,8),            /*用量                                   */
rpi20       varchar2(18)             /*来源BOM 的ROWID                        */
                                     /*來源BOM 的ROWID                        */
);

alter table rpi_file add  constraint rpi_pk primary key  (rpi01,rpi04,rpi05) enable validate;
grant select on rpi_file to tiptopgp;
grant update on rpi_file to tiptopgp;
grant delete on rpi_file to tiptopgp;
grant insert on rpi_file to tiptopgp;
grant index on rpi_file to public;
grant select on rpi_file to ods;
