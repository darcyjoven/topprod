/*
================================================================================
檔案代號:pnr_file
檔案名稱:请采购预算单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pnr_file
(
pnr01       varchar2(10) NOT NULL,   /*预算编号                               */
                                     /*預算編號                               */
pnr02       varchar2(24) NOT NULL,   /*科目编号                               */
                                     /*科目編號                               */
pnr03       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
pnr04       number(5) NOT NULL,      /*年度                                   */
pnr05       varchar2(1),             /*预算超限处理方式                       */
                                     /*正確值 1/2/3                           */
                                     /*1:不做控制                             */
                                     /*2:預算超限時于以警告                   */
                                     /*3:預算超限時拒絕接受                   */
pnr06       varchar2(1),             /*递延否                                 */
                                     /*遞延否                                 */
pnr07       number(20,6),            /*年度原始预算 (a)                       */
                                     /*年度原始預算 (a)                       */
pnr08       number(20,6),            /*年度追加金额 (b)                       */
                                     /*年度追加金額 (b)                       */
pnr09       number(20,6),            /*年度挪用金额 (c)                       */
                                     /*年度挪用金額 (c)                       */
pnr10       number(20,6),            /*年度总预算金额  = (a) + (b) + (c)      */
                                     /*年度總預算金額  = (a) + (b) + (c)      */
pnracti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
pnruser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
pnrgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
pnrmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
pnrdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
pnroriu     varchar2(10),            /*资料建立者                             */
pnrorig     varchar2(10)             /*资料建立部门                           */
);

alter table pnr_file add  constraint pnr_pk primary key  (pnr01,pnr02,pnr03,pnr04) enable validate;
grant select on pnr_file to tiptopgp;
grant update on pnr_file to tiptopgp;
grant delete on pnr_file to tiptopgp;
grant insert on pnr_file to tiptopgp;
grant index on pnr_file to public;
grant select on pnr_file to ods;
