/*
================================================================================
檔案代號:azb_file
檔案名稱:签核人员档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azb_file
(
azb01       varchar2(10) NOT NULL,   /*签核人员代码                           */
                                     /*簽核人員代碼                           */
azb02       varchar2(8),             /*口令                                   */
                                     /*密碼                                   */
azb06       number(20,6),            /*金额                                   */
                                     /*金額                                   */
azbacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
azbuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
azbgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
azbmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
azbdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
azboriu     varchar2(10),            /*资料建立者                             */
azborig     varchar2(10)             /*资料建立部门                           */
);

alter table azb_file add  constraint azb_pk primary key  (azb01) enable validate;
grant select on azb_file to tiptopgp;
grant update on azb_file to tiptopgp;
grant delete on azb_file to tiptopgp;
grant insert on azb_file to tiptopgp;
grant index on azb_file to public;
grant select on azb_file to ods;
