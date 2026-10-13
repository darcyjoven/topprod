/*
================================================================================
檔案代號:qcd_file
檔案名稱:料件检验项目AQL设置作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qcd_file
(
qcd01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
qcd02       varchar2(10) NOT NULL,   /*检验项目                               */
                                     /*檢驗項目                               */
qcd03       varchar2(1),             /*检验项目缺点等级                       */
                                     /*檢驗項目缺點等級     1:CR 2:MA 3:MI    */
qcd04       number(7,3),             /*AQL 允收水准                           */
                                     /*AQL 允收水準                           */
qcd05       varchar2(1),             /*检验方式                               */
                                     /*檢驗方式  1.105D/E  2.C=0              */
qcd061      number(15,3),            /*下限                                   */
qcd062      number(15,3),            /*上限                                   */
qcd07       varchar2(1),             /*是否录入明细测量值                     */
                                     /*是否輸入明細測量值                     */
qcdacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
qcduser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
qcdgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
qcdmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
qcddate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
qcd08       varchar2(1) DEFAULT '9', /*品管类型                               */
qcdorig     varchar2(10),            /*资料建立部门                           */
qcdoriu     varchar2(10),            /*资料建立者                             */
qcd09       varchar2(1) DEFAULT 'N' NOT NULL /*QC料件判定否*/
);

alter table qcd_file add  constraint qcd_pk primary key  (qcd01,qcd02) enable validate;
grant select on qcd_file to tiptopgp;
grant update on qcd_file to tiptopgp;
grant delete on qcd_file to tiptopgp;
grant insert on qcd_file to tiptopgp;
grant index on qcd_file to public;
grant select on qcd_file to ods;
