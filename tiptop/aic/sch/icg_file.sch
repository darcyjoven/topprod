/*
================================================================================
檔案代號:icg_file
檔案名稱:ICD料件DS 维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icg_file
(
icg01       varchar2(40) NOT NULL,   /*料件编号                               */
icg02       varchar2(10) NOT NULL,   /*作业编号                               */
icg03       varchar2(10) NOT NULL,   /*厂商                                   */
icg04       varchar2(20) NOT NULL,   /*Tester                                 */
icg05       number(20,6),            /*Price                                  */
icg06       number(15,3),            /*Test Time for Wafer                    */
icg07       number(15,3),            /*Index Time for Wafer                   */
icg08       number(15,3),            /*Test Time for Die                      */
icg09       number(15,3),            /*Index Time for Die                     */
icg10       number(15,6),            /*Hourly Rate                            */
icg11       number(16,8),            /*Dut                                    */
icg12       date,                    /*Programming Time                       */
icg13       varchar2(4),             /*币种                                   */
icg14       number(15,3),            /*自订字段                               */
icg15       number(15,3),            /*自订字段                               */
icg16       varchar2(1),             /*Default 厂商否                         */
icg17       date,                    /*失效日期                               */
icg18       varchar2(255),           /*Tray盘规格                             */
icg19       varchar2(255),           /*切穿模式                               */
icg20       varchar2(255),           /*切割方式                               */
icg21       number(15,6),            /*D/s Holding Yield (%)                  */
icg22       varchar2(1),             /*包装料号，串包材Bom                    */
icg23       number(15,3),            /*系数                                   */
icg24       number(20,6),            /*参考单价                               */
icg25       number(20,6),            /*UV Price                               */
icg26       number(20,6),            /*Baking Price                           */
icg27       number(15,6),            /*Lead Scan for FT                       */
icg28       varchar2(10),            /*公式代码                               */
icg29       varchar2(255),           /*Tube规格                               */
icg30       varchar2(255),           /*T&R规格                                */
icg31       varchar2(1),             /*no use                                 */
icg32       varchar2(1),             /*no use                                 */
icg33       varchar2(1),             /*no use                                 */
icgacti     varchar2(1),             /*资料有效码                             */
icgdate     date,                    /*最近更改日                             */
icggrup     varchar2(10),            /*资料所有群                             */
icgmodu     varchar2(10),            /*资料更改者                             */
icguser     varchar2(10),            /*资料所有者                             */
icgorig     varchar2(10),            /*资料建立部门                           */
icgoriu     varchar2(10)             /*资料建立者                             */
);

alter table icg_file add  constraint icg_pk primary key  (icg01,icg02,icg03,icg04) enable validate;
grant select on icg_file to tiptopgp;
grant update on icg_file to tiptopgp;
grant delete on icg_file to tiptopgp;
grant insert on icg_file to tiptopgp;
grant index on icg_file to public;
grant select on icg_file to ods;
