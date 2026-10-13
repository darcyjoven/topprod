/*
================================================================================
檔案代號:pic_file
檔案名稱:盘点标签生成参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table pic_file
(
pic01       date,                    /*作业运行日期                           */
                                     /*作業執行日期                           */
                                     /*儲存產生「盤點標籤」的作業日期。       */
pic02       varchar2(8),             /*作业运行时间                           */
                                     /*作業執行時間                           */
                                     /*儲存產生「盤點標籤」的作業時間。       */
pic03       varchar2(20),            /*作业指令编号                           */
                                     /*作業命令代號                           */
                                     /*儲存產生「盤點標籤」的作業程式代號。   */
pic04       varchar2(10),            /*作业运行人员                           */
                                     /*作業執行人員                           */
                                     /*儲存產生「盤點標籤」的作業的「logging  */
                                     /*user name」。                          */
                                     /* 現 有 庫 存                           */
pic05       varchar2(1),             /*是否生成盘点资料                       */
                                     /*是否產生盤點資料                       */
                                     /*儲存是否產生「現有庫存」盤點標籤資料。 */
                                     /*正確值為「Y/N」。                      */
pic06       varchar2(5),             /*使用「标签别」                         */
                                     /*sUse「Label Type」                     */
                                     /*Store Label Type Used By (Qty On Hand) Label Inventory Taking. Default Value Is「STK」。*/
pic07       varchar2(20),            /*设置起始单号                           */
                                     /*設定起始單號                           */
                                     /*儲存作業執行時，對現有庫存的盤點標籤預 */
                                     /*設的起始單號。                         */
pic08       varchar2(1),             /*「已无现有库存」的库存是否             */
                                     /*「已無現有庫存」的庫存是否產生盤點標籤 */
                                     /*儲存作業執行時，對現有庫存中已無庫存量 */
                                     /*的庫存產生盤點標籤資料。               */
                                     /*正確值為「Y/N」。                      */
pic09       varchar2(1),             /*当前尚未使用                           */
                                     /*目前尚未使用                           */
pic10       varchar2(1),             /*当前尚未使用                           */
                                     /*目前尚未使用                           */
pic11       varchar2(20),            /*「实际」- 起始单号                     */
                                     /*「實際」- 起始單號                     */
                                     /*儲存作業執行後，對「現有庫存」的「盤點 */
                                     /*標籤」實際使用的起始單號。             */
                                     /*系統維護。                             */
pic12       varchar2(20),            /*「实际」- 截止单号                     */
                                     /*「實際」- 截止單號                     */
                                     /*儲存作業執行後，對「現有庫存」的「盤點 */
                                     /*標籤」實際使用的截止單號。             */
                                     /*系統維護。                             */
pic13       number(10),              /*「实际」- 生成张数                     */
                                     /*「實際」- 產生張數                     */
                                     /*儲存作業執行後，對「現有庫存」的「盤點 */
                                     /*標籤」實際產生張數。                   */
                                     /*系統維護。                             */
pic14       varchar2(1),             /*是否生成「空白标签」                   */
                                     /*是否產生「空白標籤」                   */
                                     /*儲存是否產生「現有庫存」盤點使用的「空 */
                                     /*白」標籤。                             */
pic15       varchar2(5),             /*「空白标签」使用「标签别」             */
                                     /*「空白標籤」使用「標籤別」             */
                                     /*儲存「現有庫存」之「空白」盤點標籤產生 */
                                     /*時使用的「 標籤別」。                  */
                                     /*預設值與「現有庫存」之「標籤別」相同。 */
pic16       varchar2(20),            /*「空白标签」的设置起始单号             */
                                     /*「空白標籤」的設定起始單號             */
                                     /*儲存作業執行時，對現有庫存之空白盤點標 */
                                     /*籤預設的起始單號。                     */
pic17       number(10),              /*「空白标签」生成张数                   */
                                     /*「空白標籤」產生張數                   */
                                     /*儲存作業執行時，對現有庫存之空白盤點標 */
                                     /*籤產生張數。                           */
pic18       varchar2(20),            /*「实际」- 空白标签的起始单             */
                                     /*「實際」- 空白標籤的起始單號           */
                                     /*儲存作業執行後，對「現有庫存」的「空白 */
                                     /*標籤」實際使用的起始單號。             */
                                     /*系統維護。                             */
pic19       varchar2(20),            /*「实际」- 空白标签的截止单             */
                                     /*「Actual」- Blank Label Ending No.     */
                                     /*After WH/L Processing Run，System Maintain For  Actual Blank Label Ending No. (Qty On Hand)。*/
pic20       number(10),              /*「实际」- 空白标签的生成张             */
                                     /*「Actual」- Blank Label Gen. Pages     */
                                     /*After WH/L Processing Run，System Maintain For  Actual Blank Label Gen. Pages (Qty On Hand)。*/
pic21       varchar2(10),            /*资料生成时「选择顺序」                 */
                                     /*資料產生時「選擇順序」                 */
                                     /*儲存作業執行時，對「現有庫存」的資料之 */
                                     /*擷取順序。                             */
pic22       varchar2(1),             /*分群码之选择                           */
                                     /*分群碼之選擇                           */
                                     /*儲存作業執行時，對「現有庫存」的資料之 */
                                     /*擷取順序中，如有選擇料件「分群碼」時， */
                                     /*將以何為準。                           */
                                     /*正確值為「0/1/2/3/4」。                */
                                     /*0: 分群碼                              */
                                     /*1: 其它分群碼 一                       */
                                     /*2: 其它分群碼 二                       */
                                     /*3: 其它分群碼 三                       */
                                     /*4: 其它分群碼 四                       */
pic23       varchar2(1),             /*当前尚未使用                           */
                                     /*目前尚未使用                           */
pic24       varchar2(1),             /*当前尚未使用                           */
                                     /*目前尚未使用                           */
pic25       varchar2(1),             /*是否生成盘点资料                       */
                                     /*是否產生盤點資料                       */
                                     /*儲存是否產生「在製工單」盤點標籤資料。 */
                                     /*正確值為「Y/N」。                      */
                                     /* 在 製 工 單                           */
pic26       varchar2(5),             /*使用「标签别」                         */
                                     /*使用「標籤別」                         */
                                     /*儲存「在製工單」盤點標籤產生時使用的「 */
                                     /*標籤別」。                             */
                                     /*預設值為「WIP」。                      */
pic27       varchar2(20),            /*设置起始单号                           */
                                     /*設定起始單號                           */
                                     /*儲存作業執行時，對在製工單的盤點標籤預 */
                                     /*設的起始單號。                         */
pic28       varchar2(1),             /*当前尚未使用                           */
                                     /*目前尚未使用                           */
pic29       varchar2(1),             /*当前尚未使用                           */
                                     /*目前尚未使用                           */
pic30       varchar2(1),             /*当前尚未使用                           */
                                     /*目前尚未使用                           */
pic31       varchar2(20),            /*「实际」- 起始单号                     */
                                     /*「Actual」- Initail Doc. No.           */
                                     /*After WH/L Processing Run，System Maintain For Inventory Taking Label Actual Intail Doc. No.(IP W/O)。*/
pic32       varchar2(20),            /*「实际」- 截止单号                     */
                                     /*「Actual」- Ending Doc. No.            */
                                     /*After WH/L Processing Run，System Maintain For   Inventory Taking Label Actual Ending Doc. No.(IP W/O)。*/
pic33       number(10),              /*「实际」- 生成张数                     */
                                     /*「Actual」- Gen. Pages                 */
                                     /*After WH/L Processing Run，System Maintain For   Inventory Taking Label Actual Gen. Pages (IP W/O)。*/
pic34       varchar2(1),             /*是否生成「空白标签」                   */
                                     /*是否產生「空白標籤」                   */
                                     /*儲存是否產生「在製工單」盤點使用的「空 */
                                     /*白」標籤。                             */
pic35       varchar2(5),             /*「空白标签」使用「标签别」             */
                                     /*「空白標籤」使用「標籤別」             */
                                     /*儲存「在製工單」之「空白」盤點標籤產生 */
                                     /*時使用的「 標籤別」。                  */
                                     /*預設值與「在製工單」之「標籤別」相同。 */
pic36       varchar2(20),            /*「空白标签」的设置起始单号             */
                                     /*「空白標籤」的設定起始單號             */
                                     /*儲存作業執行時，對在製工單之空白盤點標 */
                                     /*籤預設的起始單號。                     */
pic37       number(10),              /*「空白标签」生成张数                   */
                                     /*「空白標籤」產生張數                   */
                                     /*儲存作業執行時，對在製工單之空白盤點標 */
                                     /*籤產生張數。                           */
pic38       varchar2(20),            /*「实际」- 空白标签的起始单             */
                                     /*「實際」- 空白標籤的起始單號           */
                                     /*儲存作業執行後，對「在製工單」的「空白 */
                                     /*標籤」實際使用的起始單號。             */
                                     /*系統維護。                             */
pic39       varchar2(20),            /*「实际」- 空白标签的截止单             */
                                     /*「實際」- 空白標籤的截止單號           */
                                     /*儲存作業執行後，對「在製工單」的「空白 */
                                     /*標籤」實際使用的截止單號。             */
                                     /*系統維護。                             */
pic40       number(10),              /*「实际」- 空白标签的生成张             */
                                     /*「實際」- 空白標籤的產生張數           */
                                     /*儲存作業執行後，對「在製工單」的「空白 */
                                     /*標籤」實際產生張數。                   */
                                     /*系統維護。                             */
pic41       varchar2(10),            /*资料生成时「选择顺序」                 */
                                     /*資料產生時「選擇順序」                 */
                                     /*儲存作業執行時，對「在製工單」的資料之 */
                                     /*擷取順序。                             */
pic42       varchar2(1),             /*当前尚未使用                           */
                                     /*目前尚未使用                           */
pic43       varchar2(1)              /*当前尚未使用                           */
                                     /*目前尚未使用                           */
);

create        index pic_02 on pic_file (pic03);
create        index pic_01 on pic_file (pic01,pic02);
grant select on pic_file to tiptopgp;
grant update on pic_file to tiptopgp;
grant delete on pic_file to tiptopgp;
grant insert on pic_file to tiptopgp;
grant index on pic_file to public;
grant select on pic_file to ods;
