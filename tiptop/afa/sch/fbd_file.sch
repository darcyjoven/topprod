/*
================================================================================
檔案代號:fbd_file
檔案名稱:固定资产调整单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbd_file
(
fbd01       varchar2(20) NOT NULL,   /*调整单号                               */
                                     /*調整單號                               */
fbd02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
fbd03       varchar2(10),            /*财产编号                               */
                                     /*財產編號                               */
fbd031      varchar2(4),             /*附号                                   */
                                     /*附號                                   */
fbd04       number(20,6),            /*取得成本                               */
fbd05       number(20,6),            /*累积折旧                               */
                                     /*累積折舊                               */
fbd06       number(5),               /*未用年限                               */
fbd07       number(20,6),            /*预估残值                               */
                                     /*預估殘值                               */
fbd08       number(15,2),            /*No Use                                 */
fbd09       number(20,6),            /*异动后取得成本                         */
                                     /*異動後取得成本                         */
fbd10       number(20,6),            /*异动后累积折旧                         */
                                     /*異動後累積折舊                         */
fbd11       number(5),               /*异动后未用年限                         */
                                     /*異動後未用年限                         */
fbd12       number(20,6),            /*异动后预估残值                         */
                                     /*異動後預估殘值                         */
fbd13       number(15,2),            /*No Use                                 */
fbd14       number(20,6),            /*税签取得成本                           */
                                     /*稅簽取得成本                           */
fbd15       number(20,6),            /*税签累积折旧                           */
                                     /*稅簽累積折舊                           */
fbd16       number(5),               /*税签未用年限                           */
                                     /*稅簽未用年限                           */
fbd17       number(20,6),            /*税签预估残值                           */
                                     /*稅簽預估殘值                           */
fbd18       number(15,2),            /*No Use                                 */
fbd19       number(20,6),            /*税签异动后取得成本                     */
                                     /*稅簽異動後取得成本                     */
fbd20       number(20,6),            /*税签异动后累积折旧                     */
                                     /*稅簽異動後累積折舊                     */
fbd21       number(5),               /*税签异动后未用年限                     */
                                     /*稅簽異動後未用年限                     */
fbd22       number(20,6),            /*税签异动后预估残值                     */
                                     /*稅簽異動後預估殘值                     */
fbd23       number(15,2),            /*No Use                                 */
fbd24       varchar2(10),            /*原因码                                 */
                                     /*原因碼                                 */
fbdud01     varchar2(255),           /*自订字段-Textedit                      */
fbdud02     varchar2(40),            /*自订字段-文字                          */
fbdud03     varchar2(40),            /*自订字段-文字                          */
fbdud04     varchar2(40),            /*自订字段-文字                          */
fbdud05     varchar2(40),            /*自订字段-文字                          */
fbdud06     varchar2(40),            /*自订字段-文字                          */
fbdud07     number(15,3),            /*自订字段-数值                          */
fbdud08     number(15,3),            /*自订字段-数值                          */
fbdud09     number(15,3),            /*自订字段-数值                          */
fbdud10     number(10),              /*自订字段-整数                          */
fbdud11     number(10),              /*自订字段-整数                          */
fbdud12     number(10),              /*自订字段-整数                          */
fbdud13     date,                    /*自订字段-日期                          */
fbdud14     date,                    /*自订字段-日期                          */
fbdud15     date,                    /*自订字段-日期                          */
fbdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbd052      number(20,6) DEFAULT '0' NOT NULL, /*累计折旧(财签二)*/
fbd062      number(5),               /*未用年限(财签二)                       */
fbd072      number(20,6) DEFAULT '0' NOT NULL, /*预估残值(财签二)*/
fbd092      number(20,6) DEFAULT '0' NOT NULL, /*异动后取得成本(财签二)*/
fbd102      number(20,6) DEFAULT '0' NOT NULL, /*异动后累计折旧(财签二)*/
fbd112      number(5),               /*异动后未用年限(财签二)                 */
fbd122      number(20,6) DEFAULT '0' NOT NULL, /*异动后预估残值(财签二)*/
fbd042      number(20,6) DEFAULT '0' NOT NULL /*取得成本(财签二)*/
);

create unique index fbd_02 on fbd_file (fbd01,fbd03,fbd031);
alter table fbd_file add  constraint fbd_pk primary key  (fbd01,fbd02) enable validate;
grant select on fbd_file to tiptopgp;
grant update on fbd_file to tiptopgp;
grant delete on fbd_file to tiptopgp;
grant insert on fbd_file to tiptopgp;
grant index on fbd_file to public;
grant select on fbd_file to ods;
