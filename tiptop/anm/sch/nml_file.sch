/*
================================================================================
檔案代號:nml_file
檔案名稱:现金变动码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nml_file
(
nml01       varchar2(4) NOT NULL,    /*现金变动码                             */
                                     /*現金變動碼                             */
nml02       varchar2(100),           /*说明                                   */
                                     /*說明                                   */
nml03       varchar2(2),             /*变动分类                               */
                                     /*變動分類                               */
                                     /*10.營業活動收入  11.營業活動支出       */
                                     /*20.投資活動收入  21.投資活動支出       */
                                     /*30.籌資活動收入  31.籌資活動支出       */
                                     /*40.匯率變動對現金的影響額              */
nmlacti     varchar2(1),             /*有效码                                 */
                                     /*有效碼                                 */
nmluser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nmlgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
nmlmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
nmldate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nml05       number(5),               /*行序                                   */
nmlorig     varchar2(10),            /*资料建立部门                           */
nmloriu     varchar2(10)             /*资料建立者                             */
);

alter table nml_file add  constraint nml_pk primary key  (nml01) enable validate;
grant select on nml_file to tiptopgp;
grant update on nml_file to tiptopgp;
grant delete on nml_file to tiptopgp;
grant insert on nml_file to tiptopgp;
grant index on nml_file to public;
grant select on nml_file to ods;
