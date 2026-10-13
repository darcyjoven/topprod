/*
================================================================================
檔案代號:bmi_file
檔案名稱:机种编号维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmi_file
(
bmi01       varchar2(5) NOT NULL,    /*机种代码                               */
                                     /*機種代碼                               */
bmi02       varchar2(80),            /*机种说明                               */
                                     /*機種說明                               */
bmiacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
bmiuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
bmigrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
bmimodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
bmidate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
bmiorig     varchar2(10),            /*资料建立部门                           */
bmioriu     varchar2(10)             /*资料建立者                             */
);

alter table bmi_file add  constraint bmi_pk primary key  (bmi01) enable validate;
grant select on bmi_file to tiptopgp;
grant update on bmi_file to tiptopgp;
grant delete on bmi_file to tiptopgp;
grant insert on bmi_file to tiptopgp;
grant index on bmi_file to public;
grant select on bmi_file to ods;
