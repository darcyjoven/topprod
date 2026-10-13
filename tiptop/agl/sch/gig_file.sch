/*
================================================================================
檔案代號:gig_file
檔案名稱:产品生产预算档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gig_file
(
gig01       varchar2(10) NOT NULL,   /*预算编号                               */
                                     /*預算編號                               */
gig02       varchar2(10) NOT NULL,   /*产品分类                               */
                                     /*產品分類                               */
gig03       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
gig04       number(5) NOT NULL,      /*年度                                   */
gig05       number(5) NOT NULL,      /*期别                                   */
                                     /*期別                                   */
gig06       number(15,3),            /*生产数量                               */
                                     /*生產數量                               */
gig07       number(20,6),            /*单位材料成本                           */
                                     /*單位材料成本                           */
gig08       number(20,6),            /*单位直接人工                           */
                                     /*單位直接人工                           */
gig09       number(20,6),            /*单位制造费用                           */
                                     /*單位製造費用                           */
gig10       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
gigacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
giguser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
giggrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
gigmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
gigdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
gigorig     varchar2(10),            /*资料建立部门                           */
gigoriu     varchar2(10)             /*资料建立者                             */
);

alter table gig_file add  constraint gig_pk primary key  (gig01,gig02,gig03,gig04,gig10,gig05) enable validate;
grant select on gig_file to tiptopgp;
grant update on gig_file to tiptopgp;
grant delete on gig_file to tiptopgp;
grant insert on gig_file to tiptopgp;
grant index on gig_file to public;
grant select on gig_file to ods;
