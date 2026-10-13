/*
================================================================================
檔案代號:oez_file
檔案名稱:订单单身暂存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oez_file
(
oez01       varchar2(20) NOT NULL,   /*订单单号                               */
                                     /*訂單單號 oea01                         */
oez03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
oez04       varchar2(40),            /*产品编号                               */
                                     /*產品編號 ima01                         */
oez05       varchar2(4),             /*销售单位                               */
                                     /*銷售單位 ima31                         */
oez05_fac   number(20,8) NOT NULL,   /*销售/库存单位换算率                    */
                                     /*銷售/庫存單位換算率 (To ima25)         */
oez06       varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
oez07       varchar2(10),            /*额外品名编号                           */
                                     /*額外品名編號 imc02,imc01=oez04         */
oez08       varchar2(10),            /*出货营运中心                           */
                                     /*Delivery Plant azp01                   */
oez09       varchar2(10),            /*出货仓库                               */
                                     /*出貨倉庫 imd01(img02)                  */
oez091      varchar2(10),            /*出货库位                               */
                                     /*出貨儲位 ime01(img03)                  */
oez092      varchar2(24),            /*出货批号                               */
                                     /*出貨批號       img04   No.+024         */
oez11       varchar2(40),            /*客户产品编号                           */
                                     /*客戶產品編號 obk03,obk01=oez04,obk02=oea*/
oez12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量                                   */
oez13       number(20,6) NOT NULL,   /*单价                                   */
                                     /*單價                                   */
oez14       number(20,6) NOT NULL,   /*税前金额                               */
                                     /*未稅金額                               */
oez14t      number(20,6) NOT NULL,   /*含税金额                               */
                                     /*含稅金額                               */
oez15       date,                    /*约定交货日                             */
                                     /*約定交貨日                             */
oez16       date,                    /*排定交货日                             */
                                     /*排定交貨日                             */
oez17       varchar2(1),             /*No Use                                 */
oez18       varchar2(1),             /*No Use                                 */
oez19       varchar2(1),             /*备置否                                 */
                                     /*備置否(Y/N)                            */
oez20       varchar2(1),             /*No Use                                 */
oez21       varchar2(1),             /*No Use                                 */
oez22       varchar2(10),            /*版本                                   */
oez23       number(15,3) NOT NULL,   /*待出货数量                             */
                                     /*待出貨數量 (已出貨通知或出貨未扣帳)    */
oez24       number(15,3) NOT NULL,   /*已出货数量                             */
                                     /*已出貨數量                             */
oez25       number(15,3) NOT NULL,   /*已销退数量                             */
                                     /*已銷退數量(須再換貨出貨)               */
oez26       number(15,3) NOT NULL,   /*被结案数量                             */
                                     /*被結案數量                             */
                                     /* ==>(未交量=訂單量-已出貨+已銷退-被結案)*/
oez70       varchar2(1),             /*结案否                                 */
                                     /*結案否 (Y/N)                           */
oez70d      date,                    /*结案日期                               */
                                     /*結案日期                               */
oez71       varchar2(4),             /*合约项次                               */
                                     /*合約項次 (當為合約轉入時須輸入)        */
oez72       date,                    /*No Use                                 */
oez901      number(15,3),            /*已包装数:出货时需减出货量              */
                                     /*已包裝數:出貨時需減出貨量(for cec)     */
oez902      date,                    /*包装日期                               */
                                     /*包裝日期(for cec)                      */
oez903      number(15,3),            /*累计包装数                             */
                                     /*累計包裝數(for cec)                    */
oez904      varchar2(1),             /*No Use                                 */
oez905      number(5),               /*No Use                                 */
oez906      number(5),               /*No Use                                 */
oez907      number(6,2),             /*No Use                                 */
oez908      varchar2(20),            /*No Use                                 */
oez909      varchar2(20),            /*No Use                                 */
oezplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oezlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index oez_03 on oez_file (oez15);
create        index oez_04 on oez_file (oez16);
create        index oez_02 on oez_file (oez04);
alter table oez_file add  constraint oez_pk primary key  (oez01,oez03) enable validate;
grant select on oez_file to tiptopgp;
grant update on oez_file to tiptopgp;
grant delete on oez_file to tiptopgp;
grant insert on oez_file to tiptopgp;
grant index on oez_file to public;
grant select on oez_file to ods;
