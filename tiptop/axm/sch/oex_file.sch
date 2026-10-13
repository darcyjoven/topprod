/*
================================================================================
檔案代號:oex_file
檔案名稱:订单单身暂存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oex_file
(
oex01       varchar2(20) NOT NULL,   /*订单单号                               */
                                     /*訂單單號 oea01                         */
oex03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
oex04       varchar2(40),            /*产品编号                               */
                                     /*產品編號 ima01                         */
oex05       varchar2(4),             /*销售单位                               */
                                     /*銷售單位 ima31                         */
oex05_fac   number(20,8) NOT NULL,   /*销售/库存单位换算率                    */
                                     /*銷售/庫存單位換算率 (To ima25)         */
oex06       varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
oex07       varchar2(10),            /*额外品名编号                           */
                                     /*額外品名編號 imc02,imc01=oex04         */
oex08       varchar2(10),            /*出货营运中心                           */
                                     /*Delivery Plant azp01                   */
oex09       varchar2(10),            /*出货仓库                               */
                                     /*出貨倉庫 imd01(img02)                  */
oex091      varchar2(10),            /*出货库位                               */
                                     /*出貨儲位 ime01(img03)                  */
oex092      varchar2(24),            /*出货批号                               */
                                     /*出貨批號       img04   No.+024         */
oex11       varchar2(40),            /*客户产品编号                           */
                                     /*客戶產品編號 obk03,obk01=oex04,obk02=oea*/
oex12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量                                   */
oex13       number(20,6) NOT NULL,   /*单价                                   */
                                     /*單價                                   */
oex14       number(20,6) NOT NULL,   /*税前金额                               */
                                     /*未稅金額                               */
oex14t      number(20,6) NOT NULL,   /*含税金额                               */
                                     /*含稅金額                               */
oex15       date,                    /*约定交货日                             */
                                     /*約定交貨日                             */
oex16       date,                    /*排定交货日                             */
                                     /*排定交貨日                             */
oex17       varchar2(1),             /*No Use                                 */
oex18       varchar2(1),             /*No Use                                 */
oex19       varchar2(1),             /*备置否                                 */
                                     /*備置否(Y/N)                            */
oex20       varchar2(1),             /*No Use                                 */
oex21       varchar2(1),             /*No Use                                 */
oex22       varchar2(10),            /*版本                                   */
oex23       number(15,3) NOT NULL,   /*待出货数量                             */
                                     /*待出貨數量 (已出貨通知或出貨未扣帳)    */
oex24       number(15,3) NOT NULL,   /*已出货数量                             */
                                     /*已出貨數量                             */
oex25       number(15,3) NOT NULL,   /*已销退数量                             */
                                     /*已銷退數量(須再換貨出貨)               */
oex26       number(15,3) NOT NULL,   /*被结案数量                             */
                                     /*被結案數量                             */
                                     /* ==>(未交量=訂單量-已出貨+已銷退-被結案)*/
oex70       varchar2(1),             /*结案否                                 */
                                     /*結案否 (Y/N)                           */
oex70d      date,                    /*结案日期                               */
                                     /*結案日期                               */
oex71       varchar2(4),             /*合约项次                               */
                                     /*合約項次 (當為合約轉入時須輸入)        */
oex72       date,                    /*No Use                                 */
oex901      number(15,3),            /*已包装数:出货时需减出货量              */
                                     /*已包裝數:出貨時需減出貨量(for cec)     */
oex902      date,                    /*包装日期                               */
                                     /*包裝日期(for cec)                      */
oex903      number(15,3),            /*累计包装数                             */
                                     /*累計包裝數(for cec)                    */
oex904      varchar2(1),             /*No Use                                 */
oex905      number(5),               /*No Use                                 */
oex906      number(5),               /*No Use                                 */
oex907      number(6,2),             /*No Use                                 */
oex908      varchar2(20),            /*No Use                                 */
oex909      varchar2(20),            /*No Use                                 */
oexplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oexlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index oex_03 on oex_file (oex15);
create        index oex_04 on oex_file (oex16);
create        index oex_02 on oex_file (oex04);
alter table oex_file add  constraint oex_pk primary key  (oex01,oex03) enable validate;
grant select on oex_file to tiptopgp;
grant update on oex_file to tiptopgp;
grant delete on oex_file to tiptopgp;
grant insert on oex_file to tiptopgp;
grant index on oex_file to public;
grant select on oex_file to ods;
