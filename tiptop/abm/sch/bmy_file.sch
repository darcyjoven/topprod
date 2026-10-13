/*
================================================================================
檔案代號:bmy_file
檔案名稱:ECN 元件明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bmy_file
(
bmy01       varchar2(20) NOT NULL,   /*工程变异单单号                         */
                                     /*工程變異單單號                         */
                                     /*儲存工程變異單單號。                   */
bmy02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
                                     /*儲存工程變異單明細項次。               */
bmy03       varchar2(1),             /*变异码                                 */
                                     /*變異別                                 */
                                     /*儲存工程變異單明細對產品結構元件的變異 */
                                     /*狀況別。                               */
                                     /*正確值為「1/2/3/4」。                  */
                                     /*1: 舊元件失效                          */
                                     /*2: 新元件新增生效                      */
                                     /*3: 舊元件修改                          */
                                     /*4: 取代                                */
bmy04       number(5),               /*产品结构项次                           */
                                     /*產品結構項次                           */
                                     /*儲存將被異動的產品結構元件項次。       */
bmy05       varchar2(40),            /*元件编号                               */
                                     /*元件編號                               */
                                     /*儲存將被異動的產品結構元件料件編號。   */
bmy06       number(16,8),            /*组成用量                               */
                                     /*組成用量                               */
                                     /*儲存欲異動的產品結構中該元件對主件的組 */
                                     /*成用量。                               */
bmy07       number(16,8),            /*底数                                   */
                                     /*底數                                   */
                                     /*儲存欲異動的產品結構中該元件對主件的組 */
                                     /*成用量中主件的標準基數。               */
bmy08       number(9,4),             /*损耗率                                 */
                                     /*損耗率                                 */
                                     /*儲存欲異動的在產品組合中，將發生的損耗 */
                                     /*率。                                   */
bmy09       varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
                                     /*儲存欲異動的產品組合中，元件的投入所屬 */
                                     /*主製程作業序號。                       */
bmy10       varchar2(4),             /*发料单位                               */
                                     /*發料單位                               */
bmy10_fac   number(20,8),            /*发料/料件库存单位换算率                */
                                     /*發料/料件庫存單位換算率                */
                                     /*儲存欲異動的該元件的發料單位對庫存單位 */
                                     /*換算率。                               */
bmy10_fac2  number(20,8),            /*发料/料件成本单位换算率                */
                                     /*發料/料件成本單位換算率                */
                                     /*儲存欲異動的該元件的發料單位對成本單位 */
                                     /*換算率。                               */
bmy11       varchar2(20),            /*工程图号                               */
                                     /*工程圖號                               */
bmy13       varchar2(10),            /*插件位置                               */
bmy14       varchar2(40),            /*主件编号                               */
                                     /*主件編號                               */
                                     /*儲存將被異動的產品結構主件料件編號。   */
bmy15       varchar2(1),             /*消耗件否                               */
                                     /*消耗件否 (Y/N)                         */
bmy16       varchar2(1),             /*替代特性                               */
                                     /*替代特性               #for養生2003    */
                                     /*0.不可取替代 1.取代 2.替代 5.SET替代   */
bmy17       varchar2(10),            /*主件料号版本                           */
                                     /*主件料號版本                           */
bmy171      varchar2(10),            /*主件料号当前版本                       */
                                     /*主件料號目前版本                       */
bmy18       number(5),               /*投料时距                               */
                                     /*投料時距                               */
bmy19       varchar2(10),            /*变异方式                               */
                                     /*變異方式                               */
bmy20       number(5),               /*工单开立展开选项                       */
bmy21       varchar2(1),             /*元件消耗特性                           */
bmy22       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
bmy23       number(9,4),             /*发料允许误差%                          */
bmy25       varchar2(10),            /*仓库                                   */
                                     /*倉庫別                                 */
bmy26       varchar2(10),            /*存放位置                               */
bmy27       varchar2(40),            /*新料料号                               */
bmy29       varchar2(20),            /*特性代码                               */
bmy30       varchar2(1),             /*计算方式                               */
bmy33       number(10) DEFAULT '0' NOT NULL, /*款式BOM对应项次*/
bmy34       varchar2(1),             /*是否委外代买                           */
bmyplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bmylegal    varchar2(10) NOT NULL,   /*所属法人                               */
bmy011      varchar2(10),            /*工艺编号                               */
bmy012      varchar2(10),            /*工艺段号                               */
bmy013      number(5),               /*工艺序                                 */
bmy081      number(15,3),            /*固定损耗率                             */
bmy082      number(9,4),             /*损耗批量                               */
bmy35       varchar2(1),             /*元件使用特性                           */
bmy36       date,                    /*替代失效日期                           */
bmy361      varchar2(10),            /*PLM BOM项次                            */
bmy37       varchar2(40),            /*PLM KEY                                */
ta_bmy01    varchar2(40),            /*工艺发料编号                           */
ta_bmy02    varchar2(40),            /*排版                                   */
ta_bmy03    varchar2(600),           /*位号                                   */
ta_bmy04    varchar2(40),            /*客户料号                               */
ta_bmy05    varchar2(40),            /*厂内名称                               */
ta_bmy06    varchar2(40)
);

alter table bmy_file add  constraint bmy_pk primary key  (bmy01,bmy02) enable validate;
grant select on bmy_file to tiptopgp;
grant update on bmy_file to tiptopgp;
grant delete on bmy_file to tiptopgp;
grant insert on bmy_file to tiptopgp;
grant index on bmy_file to public;
grant select on bmy_file to ods;
