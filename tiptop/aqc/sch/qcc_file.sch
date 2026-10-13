/*
================================================================================
檔案代號:qcc_file
檔案名稱:站别料件检验项目AQL设置作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qcc_file
(
qcc01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
qcc011      varchar2(6) NOT NULL,    /*作业编号                               */
                                     /*作業編號                               */
qcc02       varchar2(10) NOT NULL,   /*检验项目                               */
                                     /*檢驗項目                               */
qcc03       varchar2(1),             /*检验项目缺点等级                       */
                                     /*檢驗項目缺點等級     1:CR 2:MA 3:MI    */
qcc04       number(7,3),             /*AQL 允收水准                           */
                                     /*AQL 允收水準                           */
qcc05       varchar2(1),             /*检验方式                               */
                                     /*檢驗方式  1.105D/E  2.C=0              */
qcc061      number(15,3),            /*下限                                   */
qcc062      number(15,3),            /*上限                                   */
qcc07       varchar2(1),             /*是否录入明细测量值                     */
                                     /*是否輸入明細測量值                     */
qccacti     varchar2(1),             /*资料有效码                             */
qccuser     varchar2(10),            /*资料所有者                             */
qccgrup     varchar2(10),            /*资料所有部门                           */
qccmodu     varchar2(10),            /*资料更改者                             */
qccdate     date,                    /*最近更改日                             */
qcc08       varchar2(1) DEFAULT '9', /*品管类型                               */
qccorig     varchar2(10),            /*资料建立部门                           */
qccoriu     varchar2(10),            /*资料建立者                             */
qcc09       varchar2(1) DEFAULT 'N' NOT NULL /*QC料件判定否*/
);

alter table qcc_file add  constraint qcc_pk primary key  (qcc01,qcc011,qcc02) enable validate;
grant select on qcc_file to tiptopgp;
grant update on qcc_file to tiptopgp;
grant delete on qcc_file to tiptopgp;
grant insert on qcc_file to tiptopgp;
grant index on qcc_file to public;
grant select on qcc_file to ods;
