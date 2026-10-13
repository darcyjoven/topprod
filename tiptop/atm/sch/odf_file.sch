/*
================================================================================
檔案代號:odf_file
檔案名稱:预测影响因素档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odf_file
(
odf01       varchar2(10) NOT NULL,   /*预测版本                               */
odf02       varchar2(10) NOT NULL,   /*组织编号                               */
odf03       varchar2(10) NOT NULL,   /*产品分类                               */
odf04       date NOT NULL,           /*时距                                   */
odf05       number(9,4),             /*季节因素                               */
odf06       number(15,3),            /*市场因素                               */
odf07       number(15,3),            /*销售力度                               */
odfacti     varchar2(1),             /*资料有效码                             */
odfdate     date,                    /*最近更改日                             */
odfegrup    varchar2(10),            /*资料所有部门                           */
odfmodu     varchar2(10),            /*资料更改者                             */
odfuser     varchar2(10),            /*资料所有者                             */
odforig     varchar2(10),            /*资料建立部门                           */
odforiu     varchar2(10)             /*资料建立者                             */
);

alter table odf_file add  constraint odf_pk primary key  (odf01,odf02,odf03,odf04) enable validate;
grant select on odf_file to tiptopgp;
grant update on odf_file to tiptopgp;
grant delete on odf_file to tiptopgp;
grant insert on odf_file to tiptopgp;
grant index on odf_file to public;
grant select on odf_file to ods;
