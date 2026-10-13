/*
================================================================================
檔案代號:mmi_file
檔案名稱:工作性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table mmi_file
(
mmi01       varchar2(2) NOT NULL,    /*工作性质码                             */
                                     /*工作性質碼                             */
mmi02       varchar2(80),            /*工作性质说明                           */
                                     /*工作性質說明                           */
mmi03       varchar2(1),             /*区别                                   */
                                     /*區別 1.工作性質 2.需求類別             */
mmiacti     varchar2(1),             /*资料有效码                             */
mmiuser     varchar2(10),            /*资料所有者                             */
                                     /*Data Owener                            */
                                     /*System Maintain                        */
mmigrup     varchar2(10),            /*资料所有群                             */
                                     /*Data Group                             */
                                     /*System Maintain                        */
mmimodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By                       */
                                     /*System Maimtain                        */
mmidate     date,                    /*最近更改日                             */
                                     /*Latest Modified Date                   */
                                     /*System Maintain                        */
mmiorig     varchar2(10),            /*资料建立部门                           */
mmioriu     varchar2(10)             /*资料建立者                             */
);

alter table mmi_file add  constraint mmi_pk primary key  (mmi01) enable validate;
grant select on mmi_file to tiptopgp;
grant update on mmi_file to tiptopgp;
grant delete on mmi_file to tiptopgp;
grant insert on mmi_file to tiptopgp;
grant index on mmi_file to public;
grant select on mmi_file to ods;
