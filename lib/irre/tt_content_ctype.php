<?php
/**
 * ${extname} Content Element | ${extname}_${cename}
 */

/***************
 * Register fields
 */
$${extname}_${cename}_fields = array(
    'tx_${cename}' => array(
        'exclude' => 0,
        'label' => 'Add Item',
        'config' => array(
            'type' => 'inline',
            'foreign_table' => 'tx_${cename}',
            'foreign_field' => 'tt_content',
            'maxitems' => 999,
            'appearance' => array(
                'collapseAll' => true,
                'useSortable' => true,
                'showSynchronizationLink' => false,
                'showAllLocalizationLink' => true,
                'showPossibleLocalizationRecords' => false,
                'showRemovedLocalizationRecords' => false,
                'expandSingle' => true,
                'enabledControls' => array(
                    'localize' => true,
                ),
            ),
            'behaviour' => array(
                'localizationMode' => 'select',
                'mode' => 'select',
                'localizeChildrenAtParentLocalization' => true,
            ),
        ),
    ),
);

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTCAcolumns('tt_content', $${extname}_${cename}_fields);

/***************
 * Add Content Element: ${extname}_${cename}
 */
if (!is_array($GLOBALS['TCA']['tt_content']['types']['${extname}_${cename}'])) {
    $GLOBALS['TCA']['tt_content']['types']['${extname}_${cename}'] = [];
}

/***************
 * Add content element to seletor list
 */
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItem(
    'tt_content',
    'CType',
    [
        'Accordion',
        '${extname}_${cename}',
        'EXT:${extname}/ext_icon.png'
    ],
    '--div--',
    'after'
);

/***************
 * Assign Icon
 */
$GLOBALS['TCA']['tt_content']['ctrl']['typeicon_classes']['${extname}_${cename}'] = 'default-icon';

/***************
 * Configure element type
 */
$GLOBALS['TCA']['tt_content']['types']['${extname}_${cename}'] = array_replace_recursive(
    $GLOBALS['TCA']['tt_content']['types']['${extname}_${cename}'],
    [
        'showitem' => $showitem_default_01 . '
        header,
        tx_${cename},
        ' . $showitem_default_02,
    ]
);
