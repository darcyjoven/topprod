/*
================================================================================
檔案代號:gbh_file
檔案名稱:Window Style (4st) 设置记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gbh_file
(
gbh01       varchar2(25) NOT NULL,   /*window style 代码                      */
gbh02       varchar2(1),             /*windowtype (normal)                    */
gbh03       varchar2(1),             /*windowoptionclose (auto)               */
gbh04       varchar2(1),             /*windowoptionminimize (auto)            */
gbh05       varchar2(1),             /*windowoptionmaximize (auto)            */
gbh06       varchar2(1),             /*windowsystemmenu (auto)                */
gbh07       varchar2(1),             /*sizable (yes)                          */
gbh08       varchar2(1),             /*position (default)                     */
gbh09       varchar2(1),             /*border (normal)                        */
gbh10       varchar2(1),             /*actionpanelposition (right)            */
gbh11       varchar2(1),             /*actionpanelbuttonsize (normal)         */
gbh12       varchar2(1),             /*actionpanelbuttonspace (right)         */
gbh13       varchar2(1),             /*ringmenuposition (right)               */
gbh14       varchar2(1),             /*ringmenubuttonsize (normal)            */
gbh15       varchar2(1),             /*startmenuposition (none)               */
gbh16       varchar2(1),             /*toolbarposition (top)                  */
gbh17       varchar2(1),             /*statusbartype (default)                */
gbh18       varchar2(1),             /*No Use                                 */
gbh19       varchar2(1),             /*No Use                                 */
gbh20       varchar2(1),             /*No Use                                 */
gbhuser     varchar2(10),            /*user                                   */
gbhgrup     varchar2(10),            /*owner group                            */
gbhmodu     varchar2(10),            /*modifier                               */
gbhdate     date,                    /*modify or create date                  */
gbhacti     varchar2(1),             /*activity code                          */
gbhoriu     varchar2(10),            /*资料建立者                             */
gbhorig     varchar2(10)             /*资料建立部门                           */
);

alter table gbh_file add  constraint gbh_pk primary key  (gbh01) enable validate;
grant select on gbh_file to tiptopgp;
grant update on gbh_file to tiptopgp;
grant delete on gbh_file to tiptopgp;
grant insert on gbh_file to tiptopgp;
grant index on gbh_file to public;
grant select on gbh_file to ods;
