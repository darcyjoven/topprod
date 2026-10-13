/*
================================================================================
檔案代號:ice_file
檔案名稱:ICD料件光罩群组资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ice_file
(
ice01       varchar2(80) NOT NULL,   /*光罩群组                               */
ice02       varchar2(40) NOT NULL,   /*内编母体(ibody)料号                    */
ice03       varchar2(10),            /*工艺编号                               */
ice04       number(5) NOT NULL,      /*层                                     */
ice05       varchar2(10),            /*作业编号(光罩layer)                    */
ice06       varchar2(10),            /*光罩版本                               */
ice07       varchar2(1),             /*Metal Layer                            */
ice08       varchar2(1),             /*Code Layer                             */
ice09       varchar2(5),             /*Code 流水码                            */
ice10       varchar2(1),             /*no use                                 */
ice11       varchar2(1),             /*no use                                 */
ice12       varchar2(1),             /*no use                                 */
ice13       varchar2(40),            /*Body Mask料号                          */
ice14       varchar2(10) NOT NULL,   /*内编母体版本                           */
ice15       varchar2(40),            /*Layer Mask料号                         */
ice16       varchar2(40)             /*Code Mask料号                          */
);

alter table ice_file add  constraint ice_pk primary key  (ice01,ice02,ice14,ice04) enable validate;
grant select on ice_file to tiptopgp;
grant update on ice_file to tiptopgp;
grant delete on ice_file to tiptopgp;
grant insert on ice_file to tiptopgp;
grant index on ice_file to public;
grant select on ice_file to ods;
