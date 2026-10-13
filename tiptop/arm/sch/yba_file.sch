/*
================================================================================
檔案代號:yba_file
檔案名稱:保税营运中心基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table yba_file
(
yba01       varchar2(6) NOT NULL,    /*保税营运中心监管编号                   */
                                     /*Bonded Plant Control No.               */
yba02       varchar2(80),            /*保税营运中心全名                       */
                                     /*Bonded Plant Full Name                 */
yba03       varchar2(40),            /*厂别简称                               */
                                     /*廠別簡稱                               */
yba04       number(9,4),             /*补税税率                               */
                                     /*補稅稅率                               */
yba05       number(15,3),            /*盘差容许率                             */
                                     /*盤差容許率                             */
yba06       date,                    /*日                                     */
yba07       date,                    /*结束日                                 */
                                     /*結束日                                 */
yba08       number(5),               /*海关当前年度                           */
                                     /*海關目前年度 yyyy                      */
yba09       number(5),               /*海关当前月份                           */
                                     /*海關目前月份                           */
yba10       varchar2(10),            /*最近一次委外加工申请文号               */
                                     /*最近一次廠外加工申請文號               */
yba11       date,                    /*最近一次委外加工申请日期               */
                                     /*最近一次廠外加工申請日期               */
yba21       number(5),               /*海关年度                               */
                                     /*海關年度 yyyy                          */
yba22       number(5),               /*海关月份                               */
                                     /*海關月份                               */
yba23       varchar2(1),             /*是否为总厂                             */
                                     /*是否為總廠                             */
yba92       varchar2(10),            /*保税作业人员                           */
                                     /*保稅作業人員                           */
yba93       varchar2(1),             /*用户自定义                             */
                                     /*使用者自定義                           */
yba94       varchar2(1),             /*用户自定义                             */
                                     /*使用者自定義                           */
yba95       varchar2(1),             /*用户自定义                             */
                                     /*使用者自定義                           */
ybaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
ybauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ybagrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
ybamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
ybadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ybaorig     varchar2(10),            /*资料建立部门                           */
ybaoriu     varchar2(10)             /*资料建立者                             */
);

alter table yba_file add  constraint yba_pk primary key  (yba01) enable validate;
grant select on yba_file to tiptopgp;
grant update on yba_file to tiptopgp;
grant delete on yba_file to tiptopgp;
grant insert on yba_file to tiptopgp;
grant index on yba_file to public;
grant select on yba_file to ods;
