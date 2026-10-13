/*
================================================================================
檔案代號:qck_file
檔案名稱:材料类型检验项目AQL设置作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qck_file
(
qck01       varchar2(10) NOT NULL,   /*材料类型                               */
                                     /*材料類別                               */
qck02       varchar2(10) NOT NULL,   /*检验项目                               */
                                     /*檢驗項目                               */
qck03       varchar2(1),             /*检验项目缺点等级                       */
                                     /*檢驗項目缺點等級     1:CR 2:MA 3:MI    */
qck04       number(7,3),             /*AQL 允收水准                           */
                                     /*AQL 允收水準                           */
qck05       varchar2(1),             /*检验方式                               */
                                     /*檢驗方式  1.105D/E  2.C=0              */
qck061      number(15,3),            /*下限                                   */
qck062      number(15,3),            /*上限                                   */
qck07       varchar2(1),             /*是否录入明细测量值                     */
                                     /*是否輸入明細測量值                     */
qckacti     varchar2(1),             /*资料有效码                             */
qckuser     varchar2(10),            /*资料所有者                             */
qckgrup     varchar2(10),            /*资料所有部门                           */
qckmodu     varchar2(10),            /*资料更改者                             */
qckdate     date,                    /*最近更改日                             */
qck08       varchar2(1) DEFAULT '9', /*品管类型                               */
qckorig     varchar2(10),            /*资料建立部门                           */
qckoriu     varchar2(10),            /*资料建立者                             */
qck09       varchar2(1) DEFAULT 'N' NOT NULL, /*QC料件判定否*/
ta_qck01    varchar2(10)             /*单位                                   */
);

alter table qck_file add  constraint qck_pk primary key  (qck01,qck02) enable validate;
grant select on qck_file to tiptopgp;
grant update on qck_file to tiptopgp;
grant delete on qck_file to tiptopgp;
grant insert on qck_file to tiptopgp;
grant index on qck_file to public;
grant select on qck_file to ods;
