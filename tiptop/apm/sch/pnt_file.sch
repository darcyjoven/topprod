/*
================================================================================
檔案代號:pnt_file
檔案名稱:请采购预算挪用记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pnt_file
(
pnt01       date NOT NULL,           /*挪用日期                               */
pnt02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
pnt031      varchar2(10),            /*预算项目                               */
                                     /*預算編號  (來源)                       */
pnt032      varchar2(24),            /*科目编号                               */
                                     /*科目編號  (來源)                       */
pnt033      varchar2(10),            /*部门编号                               */
                                     /*部門編號  (來源)                       */
pnt034      number(5),               /*年度                                   */
                                     /*年度      (來源)                       */
pnt035      number(5),               /*月份                                   */
                                     /*月份      (來源)                       */
pnt041      varchar2(10),            /*预算项目                               */
                                     /*預算編號  (目的)                       */
pnt042      varchar2(24),            /*科目编号                               */
                                     /*科目編號  (目的)                       */
pnt043      varchar2(10),            /*部门编号                               */
                                     /*部門編號  (目的)                       */
pnt044      number(5),               /*年度                                   */
                                     /*年度      (目的)                       */
pnt045      number(5),               /*月份                                   */
                                     /*月份      (目的)                       */
pnt05       number(20,6),            /*挪用金额                               */
                                     /*挪用金額                               */
pntconf     varchar2(1),             /*审核否                                 */
                                     /*確認否                                 */
pntacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
pntuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
pntgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
pntmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
pntdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
pnt036      varchar2(30),            /*WBS编码                                */
pnt037      varchar2(5),             /*帐套                                   */
pnt038      varchar2(10),            /*项目编号                               */
pnt046      varchar2(30),            /*WBS编码                                */
pnt047      varchar2(5),             /*帐套                                   */
pnt048      varchar2(10),            /*项目编号                               */
pntoriu     varchar2(10),            /*资料建立者                             */
pntorig     varchar2(10)             /*资料建立部门                           */
);

alter table pnt_file add  constraint pnt_pk primary key  (pnt01,pnt02) enable validate;
grant select on pnt_file to tiptopgp;
grant update on pnt_file to tiptopgp;
grant delete on pnt_file to tiptopgp;
grant insert on pnt_file to tiptopgp;
grant index on pnt_file to public;
grant select on pnt_file to ods;
