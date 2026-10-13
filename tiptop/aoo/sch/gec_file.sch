/*
================================================================================
檔案代號:gec_file
檔案名稱:税种档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gec_file
(
gec01       varchar2(4) NOT NULL,    /*税种码                                 */
                                     /*稅別碼                                 */
gec011      varchar2(1) NOT NULL,    /*进/销项                                */
                                     /*進/銷項 (1.進項 2.銷項)                */
gec02       varchar2(80),            /*税种名称                               */
                                     /*稅別名稱                               */
gec03       varchar2(24),            /*会计科目编号                           */
                                     /*會計科目編號                           */
gec04       number(9,4),             /*税率                                   */
                                     /*稅率                                   */
gec05       varchar2(1),             /*发票联数                               */
gec06       varchar2(1),             /*1.应税 2.零税率 3.免税                 */
                                     /*1.應稅 2.零稅率 3.免稅                 */
gec07       varchar2(1),             /*单价含税否                             */
                                     /*單價含稅否 (Y.內含稅 N.不含稅)         */
                                     /*若為二聯式發票則本欄位應為 'Y.內含稅'  */
gec08       varchar2(2),             /*媒体申报格式                           */
                                     /*媒體申報格式                           */
                                     /*不申報 'XX'                            */
                                     /*進項 21/22/23/24/25/26/27/28/29        */
                                     /*銷項 31/32/33/34/35/36                 */
gecacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
gecuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
gecgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
gecmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
gecdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
gec031      varchar2(24),            /*会计科目二                             */
gecorig     varchar2(10),            /*资料建立部门                           */
gecoriu     varchar2(10),            /*资料建立者                             */
gecpos      varchar2(1) DEFAULT '1'  /*已传POS否                              */
);

alter table gec_file add  constraint gec_pk primary key  (gec01,gec011) enable validate;
grant select on gec_file to tiptopgp;
grant update on gec_file to tiptopgp;
grant delete on gec_file to tiptopgp;
grant insert on gec_file to tiptopgp;
grant index on gec_file to public;
grant select on gec_file to ods;
